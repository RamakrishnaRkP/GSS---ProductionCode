pageextension 60193 "Task Card Ext" extends "Task Card"
{
    layout
    {
        addafter(Status)
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Pre-Sales Person"; Rec."Pre-Sales Person")
            {
                ApplicationArea = All;
            }
            field("Pre-SalesPerson Name"; Rec."Pre-SalesPerson Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
