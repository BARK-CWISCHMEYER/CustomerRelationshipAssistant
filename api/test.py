
from barkutils.sql.sql_conns import get_redshift_dw_conn, sql_to_pandas
import pandas 

print('test')
df =sql_to_pandas("""with fiveorders as (
  SELECT DISTINCT user_id, lower(product_line) as product_line 
  FROM common.onebark_orders
  GROUP BY 1,2
  HAVING COUNT(DISTINCT order_ID) >= 5
 )
, thisyearorder as (
  SELECT DISTINCT user_id,  lower(product_line) as product_line 
  FROM common.onebark_orders
  Where product_line IS NOT NULL and  lower(product_line)   <> 'eats'
  GROUP BY 1,2
  HAVING MAX(shipped_at) >= '2022-01-01'
 )
,actives as (
  SELECT DISTINCT box_user_id, lower(product_line) as product_line 
  FROM common.onebark_subscriptions
   WHERE subscription_state = 'active'
 )

SELECT DISTINCT email, first_name
FROM fiveorders c
  INNER JOIN thisyearorder d ON c.user_id = d.user_id and c.product_line = d.product_line
  INNER JOIN common.onebark_customers a ON c.user_id = a.box_user_id 
 INNER JOIN actives e on e.box_user_id = c.user_id and e.product_line = c.product_line
Where a.is_ever_eats ='f' and a.box_user_id is not null and a.email is not null
    AND lower(user_location_state) NOT IN ('al','hi') 
    and user_location_country IN ('US','United States of America', 'U.S')""")
print(df.head)
df =df.to_excel('./XSellInfoEmails.xlsx')
PRINT('test')