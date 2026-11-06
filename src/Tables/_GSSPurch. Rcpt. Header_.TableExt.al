tableextension 60122 "GSSPurch. Rcpt. Header" extends "Purch. Rcpt. Header"
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
        field(60101; "GSSCurrency To Print"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
            Caption = 'Currency To Print';
        }
        field(60102; "GSSCurrency Exchange Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Exchange Rate';
        }
        field(60104; "Email Triggered"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Email Triggered';
        }
    }
}
