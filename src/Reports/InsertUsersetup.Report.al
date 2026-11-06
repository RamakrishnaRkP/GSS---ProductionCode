report 60199 InsertUsersetup
{
    Caption = 'InsertUsersetup';
    //  UsageCategory = Administration;
    //  ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
        }
    }
    trigger OnPostReport()
    var
        UserSetupRec: Record "User Setup";
        GLSetupRec: Record "General Ledger Setup";
    begin
        /* UserSetupRec.Init();
        UserSetupRec."User ID" := '';
        UserSetupRec."Allow Posting From" := CalcDate('-CM', Today);
        UserSetupRec."Allow Posting To" := CalcDate('CM', Today);
        UserSetupRec.Insert(); */
        GLSetupRec.Get();
        GLSetupRec."Journal Templ. Name Mandatory":=false;
        GLSetupRec.Modify();
    end;
}
