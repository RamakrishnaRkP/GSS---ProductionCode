query 60103 "Order Booking Standard"
{
    QueryType = API;
    APIPublisher = 'GSS';
    APIGroup = 'General';
    APIVersion = 'v1.0';
    EntityName = 'OrderBookingStandard';
    EntitySetName = 'OrderBookingStandard';

    elements
    {
        dataitem(Job;
            Job)
        {
            DataItemTableFilter = GSSStatus=filter(Released|"Pending Approval");

            column(PostingDate;
                "Creation Date")
            {
            }
            column(Customer_Name;
                "Bill-to Name")
            {
            }
            dataitem(Job_Planning_Line;
                "Job Planning Line")
            {
                DataItemLink = "Job No."=Job."No.";
                DataItemTableFilter = "Line Type"=filter(Budget|"Both Budget and Billable");

                column(Revenue;
                    "Total Price")
                {
                }
                column(Cost;
                    "Total Cost")
                {
                }
                column(GP;
                    "Total Cost")
                {
                }
                column(RebateValue;
                    "Total Cost")
                {
                }
                column(Order_No;
                    "Job No.")
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
                dataitem(Company_Information;
                    "Company Information")
                {
                    SqlJoinType = CrossJoin;

                    column(CompanyName;
                        Name)
                    {
                    }
                }
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
    var DummValue: Decimal;
}
