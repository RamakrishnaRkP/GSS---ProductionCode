pageextension 60194 "Task List Ext" extends "Task List"
{
    layout
    {
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
