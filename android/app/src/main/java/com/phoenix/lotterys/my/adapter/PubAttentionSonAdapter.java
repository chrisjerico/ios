package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.os.Bundle;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.bean.CommentBean;
import com.phoenix.lotterys.my.bean.DetailBean;
import com.phoenix.lotterys.my.bean.FavContentListBean;
import com.phoenix.lotterys.my.bean.FormulaBean;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.my.bean.PeriodsBean;
import com.phoenix.lotterys.my.fragment.PubAttentionFrag;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/10/18 14:49
 */
public class PubAttentionSonAdapter extends BaseRecyclerAdapter<Serializable> {
    private int type;
    private String id;

    public void setId(String id) {
        this.id = id;
    }

    public PubAttentionSonAdapter(Context context, List<Serializable> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    public PubAttentionSonAdapter(Context context, List<Serializable> list, int itemLayoutId,int type) {
        super(context, list, itemLayoutId);
        this.type =type;
    }

    private boolean isOk;
    public PubAttentionSonAdapter(Context context, List<Serializable> list, int itemLayoutId,int type,boolean isOk) {
        super(context, list, itemLayoutId);
        this.type =type;
        this.isOk =isOk;
    }


    @Override
    public void convert(BaseRecyclerHolder holder, Serializable item, int position, boolean isScrolling) {
            switch (type){
                case 1:
                    setFans(holder, (CommentBean.DataBean.ListBean) item,position);
                    break;
                case 2:
                    setFans1(holder, (FavContentListBean.DataBean) item,position);
                    break;
                case 4:
                    setFans(holder, (CommentBean.DataBean.ListBean) item,position);
                    break;
                case 5:
                    setFans(holder, (CommentBean.DataBean.ListBean) item,position);
                    break;
                case 11:
                    FormulaBean.DataBean.ListBean listBean = (FormulaBean.DataBean.ListBean)item;
                    if (null!=listBean){
                        StringBuffer sb  =new StringBuffer();
                        if (!StringUtils.isEmpty(listBean.getPeriods()))
                            sb.append(listBean.getPeriods()+"期:");

                        if (!StringUtils.isEmpty(listBean.getTitle()))
                            sb.append(listBean.getTitle());

                        holder.setText(R.id.context_tex,sb.toString());
                    }

                    break;
                case 12:
                    setLiuHe(holder, (MailFragBean.DataBean.ListBean) item);
                    break;
                case 13:
                    setLiuHe(holder, (MailFragBean.DataBean.ListBean) item);
                    break;
                case 99:
                    setTab(holder, (PeriodsBean.DataBean.ListBean) item);
                    break;
                case 98:
                    if (!StringUtils.isEmpty( (String) item)){
//                        ImageLoadUtil.ImageLoad(context, ((String) item),holder.getView(R.id.img_lay)
//                        ,R.drawable.err,true);
                        Glide.with(context).load((String) item).into((ImageView) holder.getView(R.id.img_lay));
                    }else {
                        ImageLoadUtil.ImageLoad(context,R.drawable.err,holder.getView(R.id.img_lay));
                    }
                    break;
                case 97:
                    setComment(holder, (CommentBean.DataBean.ListBean) item,position);
                    break;
                case 94:
                    setComment0(holder, (CommentBean.DataBean.ListBean) item,position);
                    break;
                case 96:
                    setVote(holder, (DetailBean.DataBean.VoteBean) item);
                    break;
                case 95:
                    DetailBean.DataBean.VoteBean voteBean = (DetailBean.DataBean.VoteBean) item;
                    if (null!=voteBean) {
//                        holder.setText(R.id.name_tex, voteBean.getAnimal());
                        StringBuffer sb  =new StringBuffer();
                        sb.append(voteBean.getAnimal()+" ");
                        sb.append(voteBean.getPercent()+"%");
//                        holder.setText(R.id.text_v, sb.toString());

                        holder.setText(R.id.text_v, Uiutils.setSype(
                                sb.toString() , 0, 1, "#FB594B"));

                        if (voteBean.isSele()){
                            holder.getView(R.id.text_v).setSelected(true);
                        }else{
                            holder.getView(R.id.text_v).setSelected(false);
                        }

                    }
                    break;
            }
    }

    private void setFans(BaseRecyclerHolder holder, CommentBean.DataBean.ListBean item,int position) {
        if (type==1){
            holder.getView(R.id.unfriended_tex).setVisibility(View.VISIBLE);
            holder.getView(R.id.unfriended_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.UNFRIENDED,position));
                }
            });
        }else{
            holder.getView(R.id.unfriended_tex).setVisibility(View.GONE);
        }

        CommentBean.DataBean.ListBean listBean = item;
        if (null!=listBean){
            if (!StringUtils.isEmpty(listBean.getHeadImg())){
                ImageLoadUtil.loadRoundImage(holder.getView(R.id.head_img),listBean.getHeadImg(),0);
            }else{
                ImageLoadUtil.ImageLoad(context,R.drawable.head,holder.getView(R.id.head_img));
            }

            holder.setText(R.id.context_tex,listBean.getNickname());
        }
    }

    private void setFans1(BaseRecyclerHolder holder, FavContentListBean.DataBean listBean,int position) {
            holder.getView(R.id.unfriended_tex).setVisibility(View.VISIBLE);
            holder.getView(R.id.unfriended_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.ATTENTION,position));
                }
            });

        if (null!=listBean){
            if (!StringUtils.isEmpty(listBean.getHeadImg())){
                ImageLoadUtil.loadRoundImage(holder.getView(R.id.head_img),listBean.getHeadImg(),0);
            }else{
                ImageLoadUtil.ImageLoad(context,R.drawable.head,holder.getView(R.id.head_img));
            }
            holder.setText(R.id.context_tex,listBean.getTitle());
        }
        holder.getView(R.id.head_img).setVisibility(View.GONE);
    }

    private void setVote(BaseRecyclerHolder holder, DetailBean.DataBean.VoteBean item) {
        DetailBean.DataBean.VoteBean voteBean = item;
        if (null!=voteBean) {
            holder.setText(R.id.name_tex, voteBean.getAnimal());
            StringBuffer sb  =new StringBuffer();
//                sb.append(voteBean.getNum()+"票");
//            sb.append(" ("+voteBean.getPercent()+"%"+")");
            sb.append(voteBean.getPercent()+"%");
            holder.setText(R.id.vote_v_tex, sb.toString());

            ((ProgressBar)holder.getView(R.id.progress1)).setMax(10000);
            if (!StringUtils.isEmpty(voteBean.getPercent())&&Double.parseDouble(voteBean.getPercent())>0)
            ((ProgressBar)holder.getView(R.id.progress1)).setProgress(((int)(Double.parseDouble(voteBean.getPercent())*100)));
            else
                ((ProgressBar)holder.getView(R.id.progress1)).setProgress(0);
        }
    }

    private void setComment(BaseRecyclerHolder holder, CommentBean.DataBean.ListBean item,int position) {
        CommentBean.DataBean.ListBean listBean = item;
        if (null!=listBean){
            if (!StringUtils.isEmpty(listBean.getHeadImg())){
                ImageLoadUtil.loadRoundImage(holder.getView(R.id.head_img),listBean.getHeadImg(),0);
            }else{
                ImageLoadUtil.ImageLoad(context,R.drawable.head,holder.getView(R.id.head_img));
            }

            holder.setText(R.id.name,listBean.getNickname());
            if (!StringUtils.isEmpty(listBean.getLikeNum())&&Integer.parseInt(
                    listBean.getLikeNum())>0){
//                Uiutils.setText(likeTex,listBean.getLikeNum());
                holder.setText(R.id.like_tex,listBean.getLikeNum());
            }else{
                holder.setText(R.id.like_tex,"");
            }
//            holder.setText(R.id.like_tex,listBean.getLikeNum());
            if (!StringUtils.isEmpty(listBean.getActionTime()))
            holder.setText(R.id.time_tex,Uiutils.getDateStr(listBean.getActionTime()));
            holder.setText(R.id.context_tex,listBean.getContent());
            if (StringUtils.isEmpty(listBean.getReplyCount())){
                holder.setText(R.id.reply_tex,"回复");
            }else{
                holder.setText(R.id.reply_tex,listBean.getReplyCount()+"回复");
            }


            if (!StringUtils.isEmpty(listBean.getIsLike())&&StringUtils.equals("1",
                    listBean.getIsLike())){
                holder.getView(R.id.like_tex).setSelected(true);
                ((TextView) holder.getView(R.id.like_tex)).setTextColor(
                        context.getResources().getColor(R.color.color_fe594b));
            }else{
                holder.getView(R.id.like_tex).setSelected(false);
                ((TextView) holder.getView(R.id.like_tex)).setTextColor(
                        context.getResources().getColor(R.color.color_5784ff));
            }

            holder.getView(R.id.reply_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Bundle bundle =new Bundle();
                    bundle.putInt("type", 17);
                    bundle.putString("id", listBean.getId());
                    bundle.putString("contentId", id);
                    bundle.putSerializable("listBean", listBean);
                FragmentUtilAct.startAct(context, new PubAttentionFrag(),bundle);
            }
            });

            holder.getView(R.id.like_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (isOk){
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.COMMENT1,position));
                    }else{
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.COMMENT,position));
                    }
                }
            });

            if (isOk){
                if (position!=0){
                    holder.getView(R.id.like_tex).setVisibility(View.GONE);
                }else{
                    holder.getView(R.id.like_tex).setVisibility(View.VISIBLE);
                }
                holder.getView(R.id.reply_tex).setVisibility(View.GONE);
            }
        }
    }

    private void setComment0(BaseRecyclerHolder holder, CommentBean.DataBean.ListBean item,int position) {
        CommentBean.DataBean.ListBean listBean = item;
        if (null!=listBean){
            if (!StringUtils.isEmpty(listBean.getHeadImg())){
                ImageLoadUtil.loadRoundImage(holder.getView(R.id.head_img),listBean.getHeadImg(),0);
            }else{
                ImageLoadUtil.ImageLoad(context,R.drawable.head,holder.getView(R.id.head_img));
            }

            holder.setText(R.id.name,listBean.getNickname());
            if (!StringUtils.isEmpty(listBean.getLikeNum())&&Integer.parseInt(
                    listBean.getLikeNum())>0){
//                Uiutils.setText(likeTex,listBean.getLikeNum());
                holder.setText(R.id.like_tex,listBean.getLikeNum());
            }else{
                holder.setText(R.id.like_tex,"");
            }
//            holder.setText(R.id.like_tex,listBean.getLikeNum());
            if (!StringUtils.isEmpty(listBean.getActionTime()))
                holder.setText(R.id.time_tex,Uiutils.getDateStr(listBean.getActionTime()));
            holder.setText(R.id.context_tex,listBean.getContent());
            if (StringUtils.isEmpty(listBean.getReplyCount())){
                holder.setText(R.id.reply_tex,"回复");
            }else{
                holder.setText(R.id.reply_tex,listBean.getReplyCount()+"回复");
            }


            if (!StringUtils.isEmpty(listBean.getIsLike())&&StringUtils.equals("1",
                    listBean.getIsLike())){
                holder.getView(R.id.like_tex).setSelected(true);
                ((TextView) holder.getView(R.id.like_tex)).setTextColor(
                        context.getResources().getColor(R.color.color_fe594b));
            }else{
                holder.getView(R.id.like_tex).setSelected(false);
                ((TextView) holder.getView(R.id.like_tex)).setTextColor(
                        context.getResources().getColor(R.color.color_5784ff));
            }

            holder.getView(R.id.reply_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Bundle bundle =new Bundle();
                    bundle.putInt("type", 17);
                    bundle.putString("id", listBean.getId());
                    bundle.putString("contentId", id);
                    bundle.putSerializable("listBean", listBean);
                    FragmentUtilAct.startAct(context, new PubAttentionFrag(),bundle);
                }
            });

            holder.getView(R.id.like_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (isOk){
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.COMMENT1,position));
                    }else{
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.COMMENT,position));
                    }
                }
            });

            if (isOk){
                if (position!=0){
                    holder.getView(R.id.like_tex).setVisibility(View.GONE);
                }else{
                    holder.getView(R.id.like_tex).setVisibility(View.VISIBLE);
                }
                holder.getView(R.id.reply_tex).setVisibility(View.GONE);
            }
        }

        if (null!=listBean&&null!=listBean.getSecReplyList()&&listBean.getSecReplyList().size()>0){
            holder.getView(R.id.reply_lin).setVisibility(View.VISIBLE);
            Uiutils.setRec(context, holder.getView(R.id.reply_rec), 1);
            ReplyNewAdapter tabAdapter2 =null;

            if (listBean.getSecReplyList().size()>3) {
                List<CommentBean.DataBean.SecReplyList> list =new ArrayList<>();
                for (int i =0 ;i<3;i++){
                    list.add(listBean.getSecReplyList().get(i));
                }
                tabAdapter2 = new ReplyNewAdapter(context,
                        list, R.layout.reply_adatper);
            }else{
                tabAdapter2 = new ReplyNewAdapter(context,
                        listBean.getSecReplyList(), R.layout.reply_adatper);
            }
            ((RecyclerView)holder.getView(R.id.reply_rec)).setAdapter(tabAdapter2);

            if (listBean.getSecReplyList().size()>3){
                holder.getView(R.id.all_reply_tex).setVisibility(View.VISIBLE);
                holder.setText(R.id.all_reply_tex,"查看全部"+listBean.getReplyCount()+"条回复>");
                holder.getView(R.id.all_reply_tex).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Bundle bundle =new Bundle();
                        bundle.putInt("type", 17);
                        bundle.putString("id", listBean.getId());
                        bundle.putString("contentId", id);
                        bundle.putSerializable("listBean", listBean);
                        FragmentUtilAct.startAct(context, new PubAttentionFrag(),bundle);
                    }
                });
            }else{
                holder.getView(R.id.all_reply_tex).setVisibility(View.GONE);
            }

        }else{
            holder.getView(R.id.reply_lin).setVisibility(View.GONE);
        }
    }



    private void setTab(BaseRecyclerHolder holder, PeriodsBean.DataBean.ListBean item) {
        String bb = item.getLhcNo();
        if (ShowItem.isNumeric(item.getLhcNo())) {
            DecimalFormat df=new DecimalFormat("000");
            bb=df.format(Integer.parseInt(item.getLhcNo()));
        }
        holder.setText(R.id.periods_tex, bb+"期");
//        holder.setText(R.id.periods_tex, item.getLhcNo()+"期");
        if (item.isSelected()){
            holder.getView(R.id.periods_tex).setSelected(true);
//            holder.getView(R.id.periods_lin_tex).setSelected(true);
            int color = ShareUtils.getInt(context,"ba_top",0);

            if (color!=0)
            holder.getView(R.id.periods_lin_tex).setBackgroundColor(context.getResources().getColor(color));

        }else{
            holder.getView(R.id.periods_tex).setSelected(false);
//            holder.getView(R.id.periods_lin_tex).setSelected(false);
            holder.getView(R.id.periods_lin_tex).setBackground(null);
        }
    }

    private void setLiuHe(BaseRecyclerHolder holder, MailFragBean.DataBean.ListBean item) {
        holder.getView(R.id.back_img).setVisibility(View.VISIBLE);
        holder.getView(R.id.unfriended_tex).setVisibility(View.GONE);
        MailFragBean.DataBean.ListBean listBean = item;
        if (null!=listBean){
//                        if (!StringUtils.isEmpty(listBean.getCover())){
                ImageLoadUtil.loadRoundImage(((ImageView) holder.getView(R.id.head_img)),listBean.getCover(),0);
//                        }else{
//                            ImageLoadUtil.loadRoundImage(((ImageView) holder.getView(R.id.text1)),
//                                    context.getResources().getDrawable(R.drawable.load_img_failure),0);
//                        }
            Uiutils.setText(((TextView)holder.getView(R.id.context_tex)),listBean.getName());
        }
    }
}
