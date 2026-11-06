tableextension 60133 "GSSPurchase Line" extends "Purchase Line"
{
    fields
    {
        field(50004; Modified; Boolean)
        {
            Caption = 'Modified';
            DataClassification = CustomerContent;
        }
        field(50005; Reopened; Boolean)
        {
            Caption = 'Reopened';
            DataClassification = CustomerContent;
        }
        modify("Job No.")
        {
        trigger OnAfterValidate()
        var
            PurchHeader: Record "Purchase Header";
            JobRec: Record Job;
        begin
            if "Job No." <> '' then if JobRec.Get("Job No.")then if PurchHeader.Get(Rec."Document Type", Rec."Document No.")then begin
                        // if PurchHeader."GSSJob No." = '' then begin
                        if not Confirm(StrSubstNo(Text001, "Job No.", "Document Type", "Document No."))then exit;
                        PurchHeader.Validate("GSSJob No.", "Job No.");
                        PurchHeader.Modify(false);
                    //  end;
                    end;
        end;
        }
    }
    var Text001: Label 'Do you want to update Job No. %1 on purchase document %2 %3 ?';
}
