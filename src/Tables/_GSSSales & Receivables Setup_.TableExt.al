tableextension 60100 "GSSSales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(60100; "GSSArch. Sales Doc. On Insert"; Boolean)
        {
            Caption = 'Archive Sales Doc. On Insert';
            DataClassification = CustomerContent;
        }
        field(60101; "GSSArch. Sales Doc. On Release"; Boolean)
        {
            Caption = 'Archive Sales Doc. On Release';
            DataClassification = CustomerContent;
        }
        field(60110; "GSSSkip Delete After Post"; Boolean)
        {
            Caption = 'Skip Delete After Post';
            DataClassification = CustomerContent;
        }
        field(60111; "GSSSkip Delete After SQConvert"; Boolean)
        {
            Caption = 'Skip Delete After Sales Quote-to-Order';
            DataClassification = CustomerContent;
        }
        field(60112; "GSSInvoicingReportEmail"; Text[150])
        {
            Caption = 'Email For Report Attachment';
            DataClassification = CustomerContent;
        }
    }
}
