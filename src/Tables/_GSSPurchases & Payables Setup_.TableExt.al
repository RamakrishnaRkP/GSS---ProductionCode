tableextension 60109 "GSSPurchases & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(60100; "GSSArch. Purch. Doc. On Insert"; Boolean)
        {
            Caption = 'Archive Purch. Doc. On Insert';
            DataClassification = CustomerContent;
        }
        field(60101; "GSSArch. Purch. Doc. OnRelease"; Boolean)
        {
            Caption = 'Archive Purch. Doc. On Release';
            DataClassification = CustomerContent;
        }
        field(60110; "GSSSkip Delete After Post"; Boolean)
        {
            Caption = 'Skip Delete After Post';
            DataClassification = CustomerContent;
        }
    }
}
