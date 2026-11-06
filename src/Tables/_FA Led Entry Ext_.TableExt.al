tableextension 60199 "FA Led Entry Ext" extends "FA Ledger Entry"
{
    fields
    {
        field(60000; "FA Serial No."; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset"."Serial No." where("No."=field("FA No.")));
        }
    }
}
