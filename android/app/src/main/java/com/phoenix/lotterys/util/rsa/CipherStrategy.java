package com.phoenix.lotterys.util.rsa;

/**
 * Date:2018/12/24
 * TIME:15:11
 * author：Luke
 */
public abstract  class CipherStrategy {
    public final static String CHARSET = "UTF-8";

    /**
     * 将加密内容的 Base64 编码转换为二进制内容
     * @param str
     * @return
     */
    protected byte[] decodeConvert(String str) {
        return Base64Utils.decode(str);
    }

    /**
     * 对加密后的二进制结果转换为 Base64 编码
     * @param bytes
     * @return
     */
    protected String encodeConvert(byte[] bytes) {
        return Base64Utils.encode(bytes);
    }

    /**
     * 对字符串进行加密
     *
     * @param content 需要加密的字符串
     * @return
     */
    public abstract String encrypt(String content);

    /**
     * 对字符串进行解密
     *
     * @param encryptContent 加密内容的 Base64 编码
     * @return
     */
    public abstract String decrypt(String encryptContent);

    // 文件、流等
}
