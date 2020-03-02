package com.phoenix.lotterys.linkman;

import com.phoenix.lotterys.my.bean.MailFragBean;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.Comparator;

public class PinyinComparator implements Comparator<MailFragBean.DataBean.ListBean> {

	public int compare(MailFragBean.DataBean.ListBean o1, MailFragBean.DataBean.ListBean o2) {

		if (!StringUtils.isEmpty(o1.getLetters()) && !StringUtils.isEmpty(o2.getLetters())) {
			String name = o1.getLetters();
			String name2 = o2.getLetters();

			if (!StringUtils.isEmpty(name) && !StringUtils.isEmpty(name2)) {
				if (name.equals("@")
						|| name2.equals("#")) {
					return -1;
				} else if (name.equals("#")
						|| name2.equals("@")) {
					return 1;
				} else {
					return name.compareTo(name2);
				}
			}
		}
		return 0;
	}

}
