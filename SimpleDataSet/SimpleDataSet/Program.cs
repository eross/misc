using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace SimpleDataSet
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("**** Fun with DataSets ****\n");
            DataSet carsInventoryDS = new DataSet("Car Inventory");

            carsInventoryDS.ExtendedProperties["TimeStamp"] = DateTime.Now;
            carsInventoryDS.ExtendedProperties["DataSetID"] = Guid.NewGuid();
            carsInventoryDS.ExtendedProperties["Company"] = "Intertech Training";

            // create the columns
            DataColumn carIDColumn = new DataColumn("CarID", typeof(int));
            carIDColumn.Caption = "Car ID";
            carIDColumn.ReadOnly = true;
            carIDColumn.AllowDBNull = false;
            carIDColumn.Unique = true;
            carIDColumn.AutoIncrement = true;
            carIDColumn.AutoIncrementSeed = 0;
            carIDColumn.AutoIncrementStep = 1;

            DataColumn carMakeColumn = new DataColumn("Make", typeof(string));
            DataColumn carColorColumn = new DataColumn("Color", typeof(string));
            DataColumn carPetNameColumn = new DataColumn("PetName", typeof(string));
            carPetNameColumn.Caption = "Pet Name";

            DataTable inventoryTable = new DataTable("Inventory");
            inventoryTable.Columns.AddRange(new DataColumn[] 
                    { carIDColumn, carMakeColumn, carColorColumn, carPetNameColumn });


            Console.ReadLine();
        }
    }
}
