tableextension 60112 "GSSJobs Setup" extends "Jobs Setup"
{
    fields
    {
        field(60100; "GSSSalesperson Code Mandatory"; Boolean)
        {
            Caption = 'Salesperson Code Mandatory';
            DataClassification = CustomerContent;
        }
        field(60110; "GSSRecognised Sales By Dim."; Boolean)
        {
            Caption = 'Recognised Sales By Dim.';
            DataClassification = CustomerContent;
        }
        field(60115; "GSSAuto Calc. Job WIP"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Auto Calc. Job WIP';
        }
        field(60116; "GSSAuto Post Job WIP"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Auto Post Job WIP';
        }
        field(60117; "GSSAuto Complete Job"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Auto Complete Job';
        }
    }
}
