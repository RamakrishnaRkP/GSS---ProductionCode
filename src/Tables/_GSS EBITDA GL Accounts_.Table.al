table 60101 "GSS EBITDA GL Accounts"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                if glRec.Get("Account No.")then "Account Name":=glRec.Name;
            end;
        }
        field(2; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Account No.")
        {
            Clustered = true;
        }
    }
    var glRec: Record "G/L Account";
}
