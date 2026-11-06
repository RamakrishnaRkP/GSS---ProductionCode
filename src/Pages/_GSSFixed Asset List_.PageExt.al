pageextension 60126 "GSSFixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        addafter("FA Class Code")
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = All;
            }
            field("GSSAsset No."; Rec."GSSAsset Code")
            {
                ApplicationArea = All;
            }
            field(DepreciationStartingDate; FADepreciationBook."Depreciation Starting Date")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Starting Date';
                Editable = false;
            }
            field(DepreciationEndingDate; FADepreciationBook."Depreciation Ending Date")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Ending Date';
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        LoadFADepreciationBooks();
        // CurrPage.Update();
        FADepreciationBook.Copy(FADepreciationBookOld);
    end;
    protected procedure LoadFADepreciationBooks()
    begin
        Clear(FADepreciationBookOld);
        FADepreciationBookOld.SetRange("FA No.", Rec."No.");
        if FADepreciationBookOld.Count <= 1 then begin
            if FADepreciationBookOld.FindFirst then begin
                FADepreciationBookOld.CalcFields("Book Value");
            end;
        end
        else
        begin
        end;
    end;
    var FADepreciationBookOld: Record "FA Depreciation Book";
    protected var FADepreciationBook: Record "FA Depreciation Book";
}
