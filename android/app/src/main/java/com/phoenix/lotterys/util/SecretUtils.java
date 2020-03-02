package com.phoenix.lotterys.util;

import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.phoenix.lotterys.util.rsa.RSACipherStrategy;
import com.phoenix.lotterys.util.rsa.SecurityConfig;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;


/**
 * SecretUtils {3DES加密解密的工具类 }
 */
public class SecretUtils {

    //定义加密算法，有DES、DESede(即3DES)、Blowfish
    private static final String Algorithm = "DESede";
//    private static final String PASSWORD_CRYPT_KEY = "2012PinganVitality075522628888ForShenZhenBelter075561869839";


    /**
     * 加密方法
     *
     * @param src 源数据的字节数组
     * @param
     * @return
     */
    public static byte[] encryptMode(byte[] src, String PASSWORD_CRYPT_KEY) {
        try {
            SecretKey deskey = new SecretKeySpec(build3DesKey(PASSWORD_CRYPT_KEY), Algorithm);    //生成密钥
            Cipher c1 = Cipher.getInstance(Algorithm);    //实例化负责加密/解密的Cipher工具类
            c1.init(Cipher.ENCRYPT_MODE, deskey);    //初始化为加密模式
            return c1.doFinal(src);
        } catch (java.security.NoSuchAlgorithmException e1) {
            e1.printStackTrace();
        } catch (javax.crypto.NoSuchPaddingException e2) {
            e2.printStackTrace();
        } catch (java.lang.Exception e3) {
            e3.printStackTrace();
        }
        return null;
    }


    /**
     * 解密函数
     *
     * @param src 密文的字节数组
     * @return
     */
    public static byte[] decryptMode(byte[] src, String PASSWORD_CRYPT_KEY) {
        try {
            SecretKey deskey = new SecretKeySpec(build3DesKey(PASSWORD_CRYPT_KEY), Algorithm);
            Cipher c1 = Cipher.getInstance(Algorithm);
            c1.init(Cipher.DECRYPT_MODE, deskey);    //初始化为解密模式
            return c1.doFinal(src);
        } catch (java.security.NoSuchAlgorithmException e1) {
            e1.printStackTrace();
        } catch (javax.crypto.NoSuchPaddingException e2) {
            e2.printStackTrace();
        } catch (java.lang.Exception e3) {
            e3.printStackTrace();
        }
        return null;
    }


    /*
     * 根据字符串生成密钥字节数组
     * @param keyStr 密钥字符串
     * @return
     * @throws UnsupportedEncodingException
     */
    public static byte[] build3DesKey(String keyStr) throws UnsupportedEncodingException {
        byte[] key = new byte[24];    //声明一个24位的字节数组，默认里面都是0
        byte[] temp = keyStr.getBytes("UTF-8");    //将字符串转成字节数组

        /*
         * 执行数组拷贝
         * System.arraycopy(源数组，从源数组哪里开始拷贝，目标数组，拷贝多少位)
         */
        if (key.length > temp.length) {
            //如果temp不够24位，则拷贝temp数组整个长度的内容到key数组中
            System.arraycopy(temp, 0, key, 0, temp.length);
        } else {
            //如果temp大于24位，则拷贝temp数组24个长度的内容到key数组中
            System.arraycopy(temp, 0, key, 0, key.length);
        }
        return key;
    }

    public static String getRandomString(int length) {
        //1.  定义一个字符串（A-Z，a-z，0-9）即62个数字字母；
        String str = "zxcvbnmlkjhgfdsaqwertyuiopQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
        //2.  由Random生成随机数
        Random random = new Random();
        StringBuffer sb = new StringBuffer();
        //3.  长度为几就循环几次
        for (int i = 0; i < length; ++i) {
            //从62个的数字或字母中选择
            int number = random.nextInt(62);
            //将产生的数字通过length次承载到sb中
            sb.append(str.charAt(number));
        }
        //将承载的字符转换成字符串
        return sb.toString();
    }

    public static void main(String[] args) {
//这里的32是生成32位随机码，根据你的需求，自定义
        String random1 = getRandomString(32);
        System.out.println(random1);

        String msg = "3DES加密解密案例";
        System.out.println("【加密前】：" + msg);
        //加密
        byte[] secretArr = SecretUtils.encryptMode(msg.getBytes(), "");
        System.out.println("【加密后】：" + new String(secretArr));
        //解密
        byte[] myMsgArr = SecretUtils.decryptMode(secretArr, "");
        System.out.println("【解密后】：" + new String(myMsgArr));
    }

    public static final String random1 = SecretUtils.getRandomString(32);

    //加密密码
    public static String DESedePassw(String param) {
        if(TextUtils.isEmpty(param)){
            return "";
        }
        try {
           String  md5pwd = Md5.getMD5(param);
            if(!Constants.ENCRYPT){
                return md5pwd;
            }
            byte[] pwd = SecretUtils.encryptMode(md5pwd.getBytes(), random1);
            try {
                return new String(Base64.encode(pwd, Base64.DEFAULT), "UTF-8");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }

    //加密非密码参数
    public static String DESede(String param) {
        if(TextUtils.isEmpty(param)){
            return "";
        }
        if(!Constants.ENCRYPT){
            return param;
        }
            byte[] pwd = SecretUtils.encryptMode(param.getBytes(), random1);
            try {
                return new String(Base64.encode(pwd, Base64.DEFAULT), "UTF-8");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();

            }
        return "";
    }

    public static String ENSede(String param) {
        if (TextUtils.isEmpty(param)) {
            return "";
        }
        if (!Constants.ENCRYPT) {
            return param;
        }
        try {
            byte[] pwd = SecretUtils.decryptMode(Base64.decode(unicodeToString(param), Base64.DEFAULT), random1);
            return new String(pwd, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();

        }
        return param;
    }

    public static String RsaToken(){
        RSACipherStrategy rsaCipherStrategy = new RSACipherStrategy();
        rsaCipherStrategy.initPublicKey(SecurityConfig.RSA_PUCLIC_KEY);

        return rsaCipherStrategy.encrypt("2_" + random1);
    }

    public static String unicodeToString(String unicode) {
        unicode = unicode.replaceAll("\n", "");
        unicode = unicode.replaceAll("\\\\u003d", "=");
        return unicode;
    }

    public static void encodeJson(JsonElement jsonElement) {
        if (!Constants.ENCRYPT) {
            return;
        }
        if (jsonElement.isJsonNull()) {
            return;
        }

        if (jsonElement.isJsonArray()) {
            JsonArray ja = jsonElement.getAsJsonArray();
            if (null != ja) {
                for (JsonElement ae : ja) {
                    encodeJson(ae);
                }
            }
        }

        if (jsonElement.isJsonObject()) {
            Set<Map.Entry<String, JsonElement>> es = jsonElement.getAsJsonObject().entrySet();
            for (Map.Entry<String, JsonElement> en : es) {
                if (en.getValue().isJsonObject() || en.getValue().isJsonArray()) {
                    encodeJson(en.getValue());
                }
                if (en.getValue().isJsonPrimitive()) {
                    en.setValue(new JsonPrimitive(SecretUtils.ENSede(en.getValue().getAsString())));
                }
            }
        }
    }

}