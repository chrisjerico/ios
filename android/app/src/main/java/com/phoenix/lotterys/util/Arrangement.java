package com.phoenix.lotterys.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Greated by Luke
 * on 2019/7/30
 */
public class Arrangement {
    /**
     * 计算阶乘数，即n! = n * (n-1) * ... * 2 * 1
     */
    static List<String> list = new ArrayList<>();
    private static long factorial(int n) {
        long sum = 1;
        while( n > 0 ) {
            sum = sum * n--;
        }
        return sum;
    }

    /**
     * 排列计算公式A = n!/(n - m)!
     */
    public static long arrangement(int m, int n) {
        return m <= n ? factorial(n) / factorial(n - m) : 0;
    }

    /**
     * 排列选择（从列表中选择n个排列）
     * @param dataList 待选列表
     * @param n 选择个数
     */
    public static void arrangementSelect(String[] dataList, int n) {
//        System.out.println(String.format("A(%d, %d) = %d", dataList.length, n, arrangement(n, dataList.length)));
        arrangementSelect(dataList, new String[n], 0);
    }

    /**
     * 排列选择
     * @param dataList 待选列表
     * @param resultList 前面（resultIndex-1）个的排列结果
     * @param resultIndex 选择索引，从0开始
     */
    private static void arrangementSelect(String[] dataList, String[] resultList, int resultIndex) {
        int resultLen = resultList.length;
        if(resultIndex >= resultLen) { // 全部选择完时，输出排列结果
            System.out.println(Arrays.asList(resultList));
//            list.add(resultList+"");
            return;
        }

        // 递归选择下一个
        for(int i = 0; i < dataList.length; i++) {
            // 判断待选项是否存在于排列结果中
            boolean exists = false;
            for (int j = 0; j < resultIndex; j++) {
                if (dataList[i].equals(resultList[j])) {
                    exists = true;
                    break;
                }
            }
            if (!exists) { // 排列结果不存在该项，才可选择
                resultList[resultIndex] = dataList[i];
                arrangementSelect(dataList, resultList, resultIndex + 1);
            }
        }
    }

    /**
     * 组合计算公式C<sup>m</sup><sub>n</sub> = n! / (m! * (n - m)!)
     * @param m
     * @param n
     * @return
     */
    public static long combination(int m, int n) {
        return m <= n ? factorial(n) / (factorial(m) * factorial((n - m))) : 0;
    }

    /**
     * 组合选择（从列表中选择n个组合）
     * @param dataList 待选列表
     * @param n 选择个数
     */
    public static void combinationSelect(String[] dataList, int n) {
        System.out.println(String.format("C(%d, %d) = %d", dataList.length, n, combination(n, dataList.length)));
        combinationSelect(dataList, 0, new String[n], 0);
//        return null;
    }

    /**
     * 组合选择
     * @param dataList 待选列表
     * @param dataIndex 待选开始索引
     * @param resultList 前面（resultIndex-1）个的组合结果
     * @param resultIndex 选择索引，从0开始
     */
    private static void combinationSelect(String[] dataList, int dataIndex, String[] resultList, int resultIndex) {
        int resultLen = resultList.length;
        int resultCount = resultIndex + 1;
        list.add(resultList+"");
        if (resultCount > resultLen) { // 全部选择完时，输出组合结果
            System.out.println(Arrays.asList(resultList));
            return ;
        }
        // 递归选择下一个
        for (int i = dataIndex; i < dataList.length + resultCount - resultLen; i++) {
            resultList[resultIndex] = dataList[i];
            combinationSelect(dataList, i + 1, resultList, resultIndex + 1);
        }
    }

    public static void main(String[] args) {
        String[] array = new String[4];

        array[0] = "00";
        array[1] = "11";
        array[2] = "22";
        array[3] = "33";
        /**
         * 测试排列
         */
        System.out.println("测试排列：");
        arrangementSelect(array, array.length);

        /**
         * 测试组合
         */
        System.out.println("测试组合：");
        for(int i = 1; i <= array.length; i++){
            combinationSelect(array, i);
        }
    }
}
