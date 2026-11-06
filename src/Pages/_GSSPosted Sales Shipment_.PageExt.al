pageextension 60149 "GSSPosted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("No.")
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
