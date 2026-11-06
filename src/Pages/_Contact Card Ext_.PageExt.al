pageextension 60180 "Contact Card Ext" extends "Contact Card"
{
    layout
    {
        modify("E-Mail")
        {
            ShowMandatory = true;
        }
        addlast(General)
        {
            field("Company Name New"; Rec."Company Name New")
            {
                ApplicationArea = All;
            }
        }
        moveafter(Name; "E-Mail")
    }
    trigger OnClosePage()
    begin
        Rec.TestField("E-Mail");
    end;
    trigger OnModifyRecord(): Boolean begin
        Rec.TestField("E-Mail");
    end;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean begin
        Rec.TestField("E-Mail");
    end;
}
