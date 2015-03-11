-- start query 1 in stream 0 using template query63.tpl
select
  *
from
  (select
    /*+ MAPJOIN(item, store, date_dim) */
    i_manager_id,
    sum(ss_sales_price) sum_sales
    -- avg(sum(ss_sales_price)) over(partition by i_manager_id) avg_monthly_sales
  from
    tpcds.store_sales store_sales
    join tpcds.item item on (store_sales.ss_item_sk = item.i_item_sk)
    join tpcds.store store on (store_sales.ss_store_sk = store.s_store_sk)
    join tpcds.date_dim date_dim on (store_sales.ss_sold_date_sk = date_dim.d_date_sk)
  where
    ss_sold_date_sk between 2451911 and 2452275  -- partition key filter
    -- ss_date between '2001-01-01' and '2001-12-31'
    and d_month_seq in (1212, 1212 + 1, 1212 + 2, 1212 + 3, 1212 + 4, 1212 + 5, 1212 + 6, 1212 + 7, 1212 + 8, 1212 + 9, 1212 + 10, 1212 + 11)
    and (
          (i_category in('Books', 'Children', 'Electronics')
            and i_class in('personal', 'portable', 'refernece', 'self-help')
            and i_brand in('scholaramalgamalg #14', 'scholaramalgamalg #7', 'exportiunivamalg #9', 'scholaramalgamalg #9')
          )
          or 
          (i_category in('Women', 'Music', 'Men')
            and i_class in('accessories', 'classical', 'fragrances', 'pants')
            and i_brand in('amalgimporto #1', 'edu packscholar #1', 'exportiimporto #1', 'importoamalg #1')
          )
        )
  group by
    i_manager_id,
    d_moy
  ) tmp1
-- where
--   case when avg_monthly_sales > 0 then abs(sum_sales - avg_monthly_sales) / avg_monthly_sales else null end > 0.1
order by
  i_manager_id,
  -- avg_monthly_sales,
  sum_sales
limit 100;
-- end query 1 in stream 0 using template query63.tpl
exit;
