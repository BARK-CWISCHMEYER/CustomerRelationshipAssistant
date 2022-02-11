
/* 
    Date: 
    - 02-10-2022
    Author, Department: 
    - Collin Wischmeyer, Eats BI
    Sponsor, Department: 
    - None, None
    Treatment, description: 
    - DogBirthday, A treatment to let consultants and customers know that a dog has a birthday comming up
                    - Also to present a survey to customers on how our service was 
    Desired population:
    - dogs with birthdays in the next 60 days
    Testing split:
    - 33/33/33, test/variant1/variant2
    - variants differ by including current name or not
    Exclusions:
    - N/A - add a note about business logic
    Ect:
    - 
    - N/A - add any addn'l relevant info
*/

/********   ********   ********   ********   ********   ********   ********   ********/
/********   Dev pull, need to filer on age                          *******/
/********   ********   ********   ********   ********   ********   ********   ********/


INSERT INTO collinw.treatment_dogBirthday (              
        dog_id ,                
        product ,  
        variant ,    
        current ,      
        days_till_birthday,
        curr_age,
        dog_name
        )  
/*A random set of ten */

SELECT dog_age
        ,product_line
        ,CASE 
            WHEN RAND()<.33 THEN 0 
            WHEN RAND()<.66 THEN 1
            ELSE 2
        END as variant 
        ,1
        ,datediff('day' ,date_add('day', ISNULL(dog_birthday_day,1), date_add('month', ISNULL(dog_birthday_month,1),CAST(ISNULL(dog_birthday_year,2020) ::varchar(10)|| '01' || '01' as date) )) , GETDATE()) 
        ,dog_age
        ,dog_name
FROM common.onebark_subscriptions 
where --datediff('day' ,date_add('day', ISNULL(dog_birthday_day,1), date_add('month', ISNULL(dog_birthday_month,1),CAST(ISNULL(dog_birthday_year,2020) ::varchar(10)|| '01' || '01' as date) )) , GETDATE()) <30 and 
         dog_birthday_year  > 2000 and  dog_birthday_year<2022
ORDER BY 5 asc
limit 10

--in prod this would pull all of these folks of course, but here we limit in interest of quey run times 

/*Getting some with an overlap for test cases */
/*

SELECT a.box_user_id
        ,'eats'
        ,CASE 
            WHEN RAND()<.5 THEN 0 
            ELSE 1 
        END as variant 
        ,1
        , 53 + (10 - (10 *RAND()) )
FROM common.onebark_customers a
        LEFT JOIN 
where(total_active_classic_subscriptions+total_active_bright_subscriptions + total_active_superchewer_subscriptions ) > 1
        and  is_ever_eats::int = 0

limit 5--in prod this would pull all of these folks of course, but here we limit in interest of quey run times 


UNION 

SELECT a.box_user_id
        ,'eats'
        ,CASE 
            WHEN RAND()<.5 THEN 0 
            ELSE 1 
        END as variant 
        ,1
        , 53 + (10 - (10 *RAND()) )
FROM common.onebark_customers a
where(total_active_classic_subscriptions+total_active_bright_subscriptions + total_active_superchewer_subscriptions ) > 1
        and  is_ever_eats::int = 0

limit 5--in prod this would pull all of these folks of course, but here we limit in interest of quey run times 

UNION 

SELECT a.box_user_id
        ,'eats'
        ,CASE 
            WHEN RAND()<.5 THEN 0 
            ELSE 1 
        END as variant 
        ,1
        , 53 + (10 - (10 *RAND()) )
FROM common.onebark_customers a
where(total_active_classic_subscriptions+total_active_bright_subscriptions + total_active_superchewer_subscriptions ) > 1
        and  is_ever_eats::int = 0

limit 5--in prod this would pull all of these folks of course, but here we limit in interest of quey run times 
)
*/
