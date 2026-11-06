reportextension 60100 "GSSFixed Asset - Book Value 01" extends "Fixed Asset - Book Value 01"
{
    RDLCLayout = './src/Reports/Layouts/FA-Book-Value-1.rdl';

    dataset
    {
        add("Fixed Asset")
        {
            column(GSSAssetCode; "GSSAsset Code")
            {
            }
            column(FA_Subclass_Code; "FA Subclass Code")
            {
            }
            column(AcquisitionDate; FADeprBook1."Acquisition Date")
            {
            }
            column("DisposalDate"; FADeprBook1."Disposal Date")
            {
            }
            column(ProceedsOnDisposal; FADeprBook1."Proceeds on Disposal")
            {
            }
        }
        modify("Fixed Asset")
        {
        trigger OnAfterAfterGetRecord()
        var
            myInt: Integer;
        begin
            Clear(FADeprBook1);
            if FADeprBook1.Get("Fixed Asset"."No.", 'COMPANY')then FADeprBook1.CalcFields("Book Value", "Proceeds on Disposal");
        end;
        }
    }
    requestpage
    {
        layout
        {
            modify(DeprBookCode)
            {
                trigger OnAfterValidate()
                begin
                end;
            }
        }
    }
    var FADeprBook1: Record "FA Depreciation Book";
}
