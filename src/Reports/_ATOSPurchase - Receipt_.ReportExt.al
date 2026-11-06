reportextension 60102 "ATOSPurchase - Receipt" extends "Purchase - Receipt"
{
    dataset
    {
        add("Purch. Rcpt. Header")
        {
            column(GSSJobNo; "GSSJob No.")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(User_ID; "User ID")
            {
            }
        }
        modify("Purch. Rcpt. Header")
        {
        }
    }
}
