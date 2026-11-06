pageextension 60107 "GSSGeneral Journal" extends "General Journal"
{
    layout
    {
        addafter(Description)
        {
        }
        addafter("Currency Code")
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("GSSJob No."; Rec."Job No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
