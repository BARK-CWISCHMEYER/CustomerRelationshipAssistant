
/* 
    Date: 
    - 02-10-2022
    Author, Department: 
    - Collin Wischmeyer, Eats BI
    Sponsor, Department: 
    - None, None
    Description: 
    - This ETL calculatates all of the treatment text and product for folks that should have 
        each treatment and inserts the result into the current_treatments table
    - It also dumps the previous contents of the table to the history table
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


with treatment_info as (
    SELECT a.treatment_code
            ,a.id_type
            ,b.product
            ,b.source_systems
            ,b.variants
            ,b.treatment_text              
            ,b.treatment_text_input_fields    
            ,b.treatment_title          
            ,b.treatment_title_input_fields    
    FROM collinw.dim_treatments a 
        LEFT JOIN collinw.treatment_details b on a.treatment_id = b.treatment_id
    

)

-- SELECT SPLIT_PART(treatment_text_input_fields, '|',1)  as splitpart
-- FROM treatment_info a 
--  WHERE a.treatment_text_input_fields='dog_name|dog_age'


            

--,to_insert as (
/*recentContact*/
        SELECT b.treatment_code  
        ,CASE WHEN b.product = 'bright|classic|sc|eats' THEN 'All' ELSE b.product END as product
        ,b.source_systems
        ,b.variants 
        ,REPLACE(treatment_text,'{0}', convo_type) as treatment_text
             --Hard coded, need to be functionalized
        ,treatment_title    
        ,a.user_id as id           
        ,'user' as id_type      
        ,GETDATE()
        FROM collinw.treatment_recentContact a 
            LEFT JOIN treatment_info b on a.product IN (b.product)
                                          and a.variant IN (b.variants)
        WHERE b.treatment_code =  'RHC'

UNION
/*dunningWarning*/
        SELECT treatment_Id  
        ,product      
        ,source_system
        ,variant      
        ,id
        ,REPLACE(REPLACE(REPLACE(treatment_text,'{0}', convo_type), '{1}',  ),'{2}' , )           
        ,id_type      
        ,insert_dt_utc
        FROM collinw.treatment_dunningWarning 
            LEFT JOIN treatment_info b on 
        WHERE b.source_table =  'SDW'
UNION
/*dogBirthday*/
        SELECT treatment_Id  
        ,product      
        ,source_system
        ,variant      
        ,id           
        ,id_type      
        ,insert_dt_utc
        FROM collinw.treatment_dogBirthday 
            LEFT JOIN treatment_info b on 
        WHERE b.source_table =  'DBR'
)

INSERT INTO collinw.current_treatments (--One row per treatment, product, source system and variant quadrupple. kept simple as it is 'exposed' 
        treatment_Id            -- Foreign key to dim_treatments and treatment_details
        ,product                 -- One per row, potentially 'All'
        ,source_system           -- One per row, potentially 'All'
        ,variant                 -- One per row. 1, 0 for test and control, 2,3.... for multi-variant tests
        ,treatment_text 
        ,treatment_title
        ,id                      -- The customer, user, subscription ... the treatment applies to
        ,id_type                 -- The type of the above id
        ,insert_dt_utc           -- Self explanatory
)