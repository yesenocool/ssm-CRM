package com.zxj.vo;

import java.util.List;

public class PaginationVo<T> {
    private Integer total;
    private List<T> dataList;

    public PaginationVo() {
    }

    public PaginationVo(Integer total, List<T> dataList) {
        this.total = total;
        this.dataList = dataList;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    @Override
    public String toString() {
        return "PaginationVo{" +
                "total=" + total +
                ", dataList=" + dataList +
                '}';
    }
}
