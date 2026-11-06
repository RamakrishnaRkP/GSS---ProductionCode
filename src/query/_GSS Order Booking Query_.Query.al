query 60100 "GSS Order Booking Query"
{
    QueryType = API;
    APIPublisher = 'GSS';
    APIGroup = 'OrderBooking';
    APIVersion = 'v1.0';
    EntityName = 'OrderBooking';
    EntitySetName = 'GSSOrderBooking';

    elements
    {
        dataitem(Job;
            Job)
        {
            DataItemTableFilter = GSSStatus=filter(Released|"Pending Approval");

            column(Order_No;
                "No.")
            {
            }
            column(Order_Date;
                "Creation Date")
            {
            }
            column(Customer_Name;
                "Bill-to Name")
            {
            }
            column(Team;
                GSSTeam)
            {
            }
            dataitem(Job_Planning_Line;
                "Job Planning Line")
            {
                DataItemLink = "Job No."=Job."No.";
                DataItemTableFilter = "Line Type"=filter(Budget|"Both Budget and Billable");

                column(ItemNo;
                    "No.")
                {
                }
                column(LOBCode;
                    "GSSGlobal Dimension 1 Code")
                {
                }
                column(GSSTotal_Billable_Price;
                    "Total Price")
                {
                }
                column(Total_Price;
                    "Total Price")
                {
                }
                column(Total_Cost;
                    "Total Cost")
                {
                }
                column(Currency_Code;
                    "Currency Code")
                {
                }
                column(Currency_Factor;
                    "Currency Factor")
                {
                }
                dataitem(Salesperson_Purchaser;
                    "Salesperson/Purchaser")
                {
                    DataItemLink = Code=Job."GSSSalesperson Code";

                    column(Sales_Person;
                        Name)
                    {
                    }
                    column(Code;
                        Code)
                    {
                    }
                    dataitem(Job_Task;
                        "Job Task")
                    {
                        DataItemLink = "Job No."=Job_Planning_Line."Job No.", "Job Task No."=Job_Planning_Line."Job Task No.";

                        column(Job_Posting_Group;
                            "Job Posting Group")
                        {
                        }
                    }
                }
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
}
