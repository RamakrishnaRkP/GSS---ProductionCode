pageextension 60192 "CreateTaskExt" extends "Create Task"
{
    layout
    {
        addafter(Location)
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
                ShowMandatory = Rec.Type = Rec.Type::"Pre-Sales";
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
