package com.good.dao;
/*
 * @author jChen
 * @detail: implements interface about good
 */
import com.good.vo.Good;
import com.jdbc.Conn;
import com.user.dao.UserDao;
import com.user.daoimpl.UserDaoimpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class GoodImpl implements GoodDao{


    @Override
    public ArrayList<Good> getGoods() throws SQLException, ClassNotFoundException {
        Conn c = new Conn();
        Connection conn = c.connection();
        String sql1 = "select * from good where isonline = ?";
        PreparedStatement pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setBoolean(1,true);
        ResultSet rs = pstmt1.executeQuery();
        ArrayList<Good> gls = new ArrayList<>();
        Good g;
        String sql2;
        ArrayList<String> pictures = null;
        while(rs.next()) {
            pictures = new ArrayList<String>();
            g = new Good(rs.getInt("goodid"),rs.getString("goodname"),rs.getString("price"),rs.getString("description"),rs.getBoolean("freeze"),rs.getBoolean("ispurchased"),rs.getBoolean("isonline"),rs.getString("userid"));
            sql2 = "select picture from goodpicture where goodid = ?";
            PreparedStatement pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1,rs.getInt("goodid"));
            ResultSet rs2 = pstmt2.executeQuery();
            while(rs2.next()){
                pictures.add(rs2.getString("picture"));
            }
            rs2.close();
            pstmt2.close();
            g.setPictures(pictures);
            gls.add(g);
        }
        rs.close();
        pstmt1.close();
        conn.close();
        return gls;
    }

    @Override
    public void releaseGood(String goodname, String price, String description, ArrayList<String> picture) throws SQLException, ClassNotFoundException {
        //连接数据库
        Conn c = new Conn();
        Connection conn = c.connection();
        //把商品信息加入数据库
        String sql1 = "insert into good(goodname,price,description,freeze,ispurchased,isonline,userid) values(?,?,?,?,?,?,?)";
        PreparedStatement pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setString(1,goodname);
        pstmt1.setString(2,price);
        pstmt1.setString(3,description);
        pstmt1.setBoolean(4,false);
        pstmt1.setBoolean(5,false);
        pstmt1.setBoolean(6,true);
        pstmt1.setString(7,null);
        pstmt1.execute();
        //找到本次加入商品的id
        String sql2 = "select goodid from good order by goodid desc limit 1";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql2);
        int goodid = 0;
        if(rs.next()){
            goodid = rs.getInt("goodid");
        }
        //将商品图片路径加入数据库
        String sql3 = "insert into goodpicture(goodid, picture) values(?,?)";
        for (String s : picture) {
            PreparedStatement pstmt2 = conn.prepareStatement(sql3);
            pstmt2.setInt(1, goodid);
            pstmt2.setString(2, s);
            pstmt2.execute();
            pstmt2.close();
        }
        pstmt1.close();
        conn.close();
    }

    @Override
    public void offLoadGood(int goodid) throws SQLException, ClassNotFoundException {
        Conn c = new Conn();
        Connection conn = c.connection();
        //通过id修改数据库中商品状态为下架状态
        String sql1 = "update good set isonline = ? where goodid = ?";
        PreparedStatement pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setBoolean(1,false);
        pstmt1.setInt(2,goodid);
        pstmt1.execute();
        pstmt1.close();
        conn.close();
    }

    @Override
    public Map<Good,String> viewHisGood() throws SQLException, ClassNotFoundException {
        Conn c = new Conn();
        Connection conn = c.connection();
        UserDao ud = new UserDaoimpl();
        //通过商品状态找出历史商品信息
        String sql = "select * from good where isonline = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setBoolean(1,false);
        ResultSet res = pstmt.executeQuery();
        Map<Good,String> gls = new HashMap<>();//商品信息列表
        Good g;//商品
        String uname;//购买人姓名
        String sql2;
        ArrayList<String> pictures = new ArrayList<>();//图片路径列表
        while(res.next()){
            g = new Good(res.getInt("goodid"),res.getString("goodname"),res.getString("price"),res.getString("description"),res.getBoolean("freeze"),res.getBoolean("ispurchased"),res.getBoolean("isonline"),res.getString("userid"));
            sql2 = "select picture from goodpicture where goodid = ?";
            PreparedStatement pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1,res.getInt("goodid"));
            ResultSet rs2 = pstmt2.executeQuery();
            while(rs2.next()){
                pictures.add(rs2.getString("picture"));
            }
            rs2.close();
            pstmt2.close();
            g.setPictures(pictures);
            uname = ud.getBuyer(g.getGoodId()).getUsername();
            gls.put(g,uname);
        }
        pstmt.close();
        conn.close();
        return gls;
    }

    @Override
    public void freezeGood(int goodid) throws SQLException, ClassNotFoundException {
        Conn c = new Conn();
        Connection conn = c.connection();
        //通过商品id修改为冻结状态
        String sql1 = "update good set freeze = true where goodid = ?";
        PreparedStatement pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setInt(1,goodid);
        pstmt1.execute();
        pstmt1.close();
        conn.close();
    }

    @Override
    public void goodBackOnline(int goodid) throws SQLException, ClassNotFoundException {
        Conn c = new Conn();
        Connection conn = c.connection();
        //通过商品id修改为解冻状态
        String sql1 = "update good set freeze = false where goodid = ?";
        PreparedStatement pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setInt(1,goodid);
        pstmt1.execute();
        pstmt1.close();
        conn.close();
    }

    @Override
    public void transactionSuccess(int goodid) throws SQLException, ClassNotFoundException {
        Conn c = new Conn();
        Connection conn = c.connection();
        //交易成功，商品下架
        //获取被选定意向购买人id
        String sql = "select userid from transaction where goodid = ? and ischosen = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1,goodid);
        pstmt.setBoolean(2,true);
        ResultSet rs = pstmt.executeQuery();
        if(rs.next()) {
            int userid = rs.getInt("userid");
            //更新good表
            String sql1 = "update good set isonline = ?, userid = ? where goodid = ?";
            PreparedStatement pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setBoolean(1, false);
            pstmt1.setInt(2, userid);
            pstmt1.setInt(3, goodid);
            pstmt1.execute();
            pstmt1.close();
            //删除这个商品的所有意向购买人
            String sql2 = "delete from transaction where goodid = ?";
            PreparedStatement pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, goodid);
            pstmt2.execute();
            pstmt2.close();
        }
        conn.close();
    }
}
