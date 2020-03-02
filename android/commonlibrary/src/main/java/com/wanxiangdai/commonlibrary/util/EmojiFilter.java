package com.wanxiangdai.commonlibrary.util;

/**
 * Created by Ykai on 2018/4/18.
 */

public class EmojiFilter {

    // 判别是否包含Emoji表情
    public static String containsEmoji(String str) {
        int len = str.length();
        StringBuffer contract = new StringBuffer();
        for (int i = 0; i < len; i++) {
            if (isEmojiCharacter(str.charAt(i)))
                contract.append("");
            else
                contract.append(str.charAt(i));
        }
        return contract.toString();
    }

    private static boolean isEmojiCharacter(char codePoint) {
        return !((codePoint == 0x0) ||
                (codePoint == 0x9) ||
                (codePoint == 0xA) ||
                (codePoint == 0xD) ||
                ((codePoint >= 0x20) && (codePoint <= 0xD7FF)) ||
                ((codePoint >= 0xE000) && (codePoint <= 0xFFFD)) ||
                ((codePoint >= 0x10000) && (codePoint <= 0x10FFFF)));
    }

}
