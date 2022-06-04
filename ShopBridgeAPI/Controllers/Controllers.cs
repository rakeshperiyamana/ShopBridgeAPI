using Microsoft.Practices.EnterpriseLibrary.Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Serialization.Json;
using System.Web;
using System.Web.Http;



public class GetItemsController : ApiController
{
    string szConnectionString = ConfigurationManager.ConnectionStrings["DBConnection"].ToString();
    Database dbsql = DatabaseFactory.CreateDatabase("DBConnection");
    [HttpGet]
    [ActionName("User")]
    public string Get()
    {

        string szResult = "";


        try
        {
            DataSet ds = dbsql.ExecuteDataSet("P_Get_Items");
            szResult = JsonConvert.SerializeObject(ds.Tables[0]);
        }
        catch (Exception ex)
        {
           
        }
        finally
        {

        }
        return szResult;
    }


}

public class InsertItemsController : ApiController
{
    string szConnectionString = ConfigurationManager.ConnectionStrings["DBConnection"].ToString();
    Database dbsql = DatabaseFactory.CreateDatabase("DBConnection");
    [HttpGet]
    [ActionName("User")]
    public string Get(string ItemCode,string ItemDescription,double Price,string UOM,int ConversionFactor)
    {

        string szResult = "";
       

        try
        {
            dbsql.ExecuteNonQuery("P_Create_New_Item", ItemCode, ItemDescription, Price,UOM, ConversionFactor);
            szResult = "Created";
        }
        catch (Exception ex)
        {
          
        }
        finally
        {
           
        }
        return szResult;
    }


}

public class UpdateItemsController : ApiController
{
    string szConnectionString = ConfigurationManager.ConnectionStrings["DBConnection"].ToString();
    Database dbsql = DatabaseFactory.CreateDatabase("DBConnection");
    [HttpGet]
    [ActionName("User")]
    public string Get(int ItemID,string ItemDescription,double Price,int UOMID, int ConversionFactor)
    {

        string szResult = "";

        try
        {
            dbsql.ExecuteNonQuery("P_Update_Item", ItemID, ItemDescription, Price, UOMID, ConversionFactor);
            szResult = "Updated";
        }
        catch (Exception ex)
        {
           
        }
        finally
        {

        }
        return szResult;
    }


}

public class DeleteItemController : ApiController
{
    string szConnectionString = ConfigurationManager.ConnectionStrings["DBConnection"].ToString();
    Database dbsql = DatabaseFactory.CreateDatabase("DBConnection");
    [HttpGet]
    [ActionName("User")]
    public string Get(int ItemID)
    {

        string szResult = "";

        try
        {
            dbsql.ExecuteNonQuery("P_Delete_Item", ItemID);
            szResult = "Deleted";
        }
        catch (Exception ex)
        {
            
        }
        finally
        {

        }
        return szResult;
    }


}
