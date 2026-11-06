tableextension 60119 "GSSPurch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
            ValidateTableRelation = true;
            Editable = false;
        }

        ///Rk

        field(60106; "PO Type"; Enum "PO Type")
        {
            Caption = 'PO Type';
            DataClassification = CustomerContent;
        }
    }
}
