package dao;

import java.util.List;

public class PaginatedResult<T> {
    private List<T> data;
    private int total;
    private int page;
    private int size;
    private int totalPages;

    public PaginatedResult(List<T> data, int total, int page, int size) {
        this.data = data;
        this.total = total;
        this.page = page;
        this.size = size;
        this.totalPages = size > 0 ? (int) Math.ceil((double) total / size) : 0;
    }

    public List<T> getData() { return data; }
    public int getTotal() { return total; }
    public int getPage() { return page; }
    public int getSize() { return size; }
    public int getTotalPages() { return totalPages; }
    public boolean hasPrev() { return page > 1; }
    public boolean hasNext() { return page < totalPages; }
}