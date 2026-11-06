xmlport 60101 GSSUpdateJobLedgerEntries
{
    Caption = 'Update Job Ledger Entries';
    Format = VariableText;
    FieldSeparator = ',';
    Direction = Both;
    Permissions = tabledata 169=m;

    schema
    {
    textelement(RootNodeName)
    {
    // tableelement(ItemLedgerEntry; "Item Ledger Entry")
    // {
    //     RequestFilterFields = "Entry No.", "Lot No.", "Serial No.", "Item Tracking";
    //     fieldelement("EntryNo."; ItemLedgerEntry."Entry No.") { }
    //     fieldelement(ItemNo; ItemLedgerEntry."Item No.") { }
    //     fieldelement(LotNo; ItemLedgerEntry."Lot No.") { }
    //     fieldelement(SerialNo; ItemLedgerEntry."Serial No.") { }
    //     fieldelement(TrackingInfo; ItemLedgerEntry."Item Tracking") { }
    //     trigger OnBeforeInsertRecord()
    //     begin
    //         UpdateILERecord();
    //         currXMLport.Skip();
    //     end;
    //     trigger OnBeforeModifyRecord()
    //     var
    //         ILE: Record "Item Ledger Entry";
    //     begin
    //         UpdateILERecord();
    //         currXMLport.Skip();
    //     end;
    // }
    tableelement(JobLedgerEntry;
    "Job Ledger Entry")
    {
    fieldelement("EntryNo";
    JobLedgerEntry."Entry No.")
    {
    }
    fieldelement("Quantity";
    JobLedgerEntry.Quantity)
    {
    }
    fieldelement(QauntityBase;
    JobLedgerEntry."Quantity (Base)")
    {
    }
    fieldelement(UnitPrice;
    JobLedgerEntry."Unit Price")
    {
    }
    fieldelement(UnitPriceLCY;
    JobLedgerEntry."Unit Price (LCY)")
    {
    }
    fieldelement(LineAmount;
    JobLedgerEntry."Line Amount")
    {
    }
    fieldelement(LineAmountLCY;
    JobLedgerEntry."Line Amount (LCY)")
    {
    }
    trigger OnBeforeInsertRecord()
    begin
        UpdateILERecord();
        currXMLport.Skip();
    end;
    trigger OnBeforeModifyRecord()
    var
        ILE: Record "Item Ledger Entry";
    begin
        UpdateILERecord();
        currXMLport.Skip();
    end;
    }
    }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    local procedure UpdateILERecord()
    var
        //ILE: Record "Item Ledger Entry";
        JobLedgerEntry1: Record "Job Ledger Entry";
    begin
        if JobLedgerEntry1.Get(JobLedgerEntry."Entry No.")then begin
            JobLedgerEntry1."Unit Price":=JobLedgerEntry."Unit Price";
            JobLedgerEntry1."Unit Price (LCY)":=JobLedgerEntry."Unit Price (LCY)";
            JobLedgerEntry1."Line Amount":=JobLedgerEntry."Line Amount";
            JobLedgerEntry1."Line Amount (LCY)":=JobLedgerEntry."Line Amount (LCY)";
            JobLedgerEntry1.Quantity:=JobLedgerEntry.Quantity;
            JobLedgerEntry1."Quantity (Base)":=JobLedgerEntry."Quantity (Base)";
            // JobLedgerEntry1."Total Price" := JobLedgerEntry."Line Amount";
            // JobLedgerEntry1."Total Price (LCY)" := JobLedgerEntry."Line Amount (LCY)";
            JobLedgerEntry1.Modify();
        end;
        currXMLport.Skip();
    end;
}
