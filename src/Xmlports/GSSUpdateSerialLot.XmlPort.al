xmlport 60100 GSSUpdateSerialLot
{
    Caption = 'GSSUpdateSerialLot';
    Format = VariableText;
    FieldSeparator = ',';
    Direction = Both;
    Permissions = tabledata 32=m,
        tabledata 169=m;

    schema
    {
    textelement(RootNodeName)
    {
    tableelement(ItemLedgerEntry;
    "Item Ledger Entry")
    {
    RequestFilterFields = "Entry No.", "Lot No.", "Serial No.", "Item Tracking";

    fieldelement("EntryNo.";
    ItemLedgerEntry."Entry No.")
    {
    }
    fieldelement(ItemNo;
    ItemLedgerEntry."Item No.")
    {
    }
    fieldelement(LotNo;
    ItemLedgerEntry."Lot No.")
    {
    }
    fieldelement(SerialNo;
    ItemLedgerEntry."Serial No.")
    {
    }
    fieldelement(TrackingInfo;
    ItemLedgerEntry."Item Tracking")
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
        ILE: Record "Item Ledger Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        if ILE.Get(ItemLedgerEntry."Entry No.")then begin
            //if ItemLedgerEntry."Lot No." <> '' then
            ILE."Lot No.":=ItemLedgerEntry."Lot No.";
            //if ItemLedgerEntry."Serial No." <> '' then
            ile."Serial No.":=ItemLedgerEntry."Serial No.";
            ILE."Item Tracking":=ItemLedgerEntry."Item Tracking";
            ile.Modify(false);
            Clear(JobLedgerEntry);
            JobLedgerEntry.SetCurrentKey("Entry No.");
            JobLedgerEntry.SetRange("Ledger Entry Type", JobLedgerEntry."Ledger Entry Type"::Item);
            JobLedgerEntry.SetRange("Ledger Entry No.", ILE."Entry No.");
            if JobLedgerEntry.FindFirst()then repeat //if ItemLedgerEntry."Lot No." <> '' then
                    JobLedgerEntry."Lot No.":=ItemLedgerEntry."Lot No.";
                    //if ItemLedgerEntry."Serial No." <> '' then
                    JobLedgerEntry."Serial No.":=ItemLedgerEntry."Serial No.";
                    JobLedgerEntry.Modify(false);
                until JobLedgerEntry.Next() = 0;
        end;
        currXMLport.Skip();
    end;
}
