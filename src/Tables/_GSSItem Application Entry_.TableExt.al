tableextension 60130 "GSSItem Application Entry" extends "Item Application Entry"
{
    fields
    {
        field(60100; "GSSPurchase Date"; Date)
        {
            Caption = 'Purchase Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60101; "GSS ItemNo."; Code[20])
        {
            Caption = 'Item No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Item No." where("Entry No."=field("Item Ledger Entry No.")));
        }
    }
}
