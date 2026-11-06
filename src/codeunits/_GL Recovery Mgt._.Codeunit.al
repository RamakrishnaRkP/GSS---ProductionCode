codeunit 60110 "GL Recovery Mgt."
{
    Permissions = tabledata "G/L Entry"=RIMD;

    // Direct-insert recovery for G/L Entry ONLY. No journal, no Codeunit 12, no other table is written.
    // Use only when you have verified VAT Entry / Detailed Cust.-Vendor Ledger Entry / Job Ledger Entry /
    // Value Entry / Dimension Set Entry are all already intact and already reference the Transaction No.
    // and Dimension Set ID values you are about to reuse here.
    //
    // HARD PLATFORM LIMIT - cannot be worked around by any insert method:
    // G/L Entry."Entry No." is AutoIncrement (SQL IDENTITY). You cannot force it back to the original
    // value. New rows get the next available Entry No., sequential from current max. Transaction No. and
    // Dimension Set ID are what preserve the links to your existing intact subledger data - Entry No. is not.
    //
    // Permissions: this extension needs an explicit permission set granting Insert on Table 17 (G/L Entry),
    // since it's a base application table, not one this extension owns.
    procedure InsertGLEntriesFromStaging()
    var
        Staging: Record "GL Recovery Staging";
        InsertedCount: Integer;
        ErrorCount: Integer;
    begin
        Staging.SetRange("Row Inserted", false);
        if not Staging.FindSet()then begin
            Message('Nothing to insert - no staging rows with Row Inserted = No.');
            exit;
        end;
        repeat if InsertSingleEntry(Staging)then InsertedCount+=1
            else
                ErrorCount+=1;
        until Staging.Next() = 0;
        Message('Done. %1 row(s) inserted into G/L Entry, %2 error(s). Check the Error Text column for any failed rows.', InsertedCount, ErrorCount);
    end;
    local procedure InsertSingleEntry(var Staging: Record "GL Recovery Staging"): Boolean var
        GLEntry: Record "G/L Entry";
    begin
        Clear(GLEntry);
        GLEntry.Init();
        // "Entry No." intentionally left at default (0) - AutoIncrement assigns it on Insert.
        GLEntry."Entry No.":=Staging."Orig. Entry No.";
        GLEntry."G/L Account No.":=Staging."G/L Account No.";
        GLEntry."Posting Date":=Staging."Posting Date";
        GLEntry."Document Type":=Staging."Document Type";
        GLEntry."Document No.":=Staging."Document No.";
        GLEntry."External Document No.":=Staging."External Document No.";
        GLEntry.Description:=Staging.Description;
        GLEntry."Bal. Account Type":=Staging."Bal. Account Type";
        GLEntry."Bal. Account No.":=Staging."Bal. Account No.";
        GLEntry.Amount:=Staging."Amount (LCY)"; // Note: "Amount" field itself does not exist on G/L Entry - only (LCY)/currency variants
        GLEntry."Debit Amount":=Staging."Debit Amount (LCY)";
        GLEntry."Credit Amount":=Staging."Credit Amount (LCY)";
        GLEntry."Additional-Currency Amount":=Staging."Additional-Currency Amount";
        GLEntry."Add.-Currency Debit Amount":=Staging."Add.-Currency Debit Amount";
        GLEntry."Add.-Currency Credit Amount":=Staging."Add.-Currency Credit Amount";
        GLEntry."Source Currency Code":=Staging."Source Currency Code";
        GLEntry."Source Currency Amount":=Staging."Source Currency Amount";
        GLEntry."Global Dimension 1 Code":=Staging."Global Dimension 1 Code";
        GLEntry."Global Dimension 2 Code":=Staging."Global Dimension 2 Code";
        GLEntry."Dimension Set ID":=Staging."Dimension Set ID"; // literal reuse - do not rebuild
        GLEntry."Job No.":=Staging."Job No.";
        GLEntry."Gen. Posting Type":=Staging."Gen. Posting Type";
        GLEntry."Gen. Bus. Posting Group":=Staging."Gen. Bus. Posting Group";
        GLEntry."Gen. Prod. Posting Group":=Staging."Gen. Prod. Posting Group";
        GLEntry."VAT Bus. Posting Group":=Staging."VAT Bus. Posting Group";
        GLEntry."VAT Prod. Posting Group":=Staging."VAT Prod. Posting Group";
        GLEntry."VAT Amount":=Staging."VAT Amount";
        GLEntry."Tax Area Code":=Staging."Tax Area Code";
        GLEntry."Tax Liable":=Staging."Tax Liable";
        GLEntry."Tax Group Code":=Staging."Tax Group Code";
        GLEntry."Document Date":=Staging."Document Date";
        GLEntry."Reason Code":=Staging."Reason Code";
        GLEntry."Source Code":=Staging."Source Code";
        GLEntry."User ID":=Staging."User ID";
        GLEntry."No. Series":=Staging."No. Series";
        GLEntry."Journal Batch Name":=Staging."Journal Batch Name";
        GLEntry."System-Created Entry":=Staging."System-Created Entry";
        GLEntry."Prior-Year Entry":=Staging."Prior-Year Entry";
        GLEntry.Quantity:=Staging.Quantity;
        GLEntry."Transaction No.":=Staging."Transaction No."; // CRITICAL: preserves link to existing subledger data
        if not TryInsertGLEntry(GLEntry)then begin
            Staging."Error Text":=CopyStr(GetLastErrorText(), 1, 250);
            Staging.Modify();
            exit(false);
        end;
        Staging."Row Inserted":=true;
        Staging."New Entry No.":=GLEntry."Entry No.";
        Staging."Error Text":='';
        Staging.Modify();
        exit(true);
    end;
    [TryFunction]
    local procedure TryInsertGLEntry(var GLEntry: Record "G/L Entry")
    begin
        GLEntry.Insert(true);
    end;
    procedure DeleteStrayZeroEntry()
    var
        GLEntry: Record "G/L Entry";
    begin
        if not GLEntry.Get(0)then begin
            Message('No G/L Entry with Entry No. = 0 found. Nothing to delete.');
            exit;
        end;
        // Sanity check against the known orphan values before allowing deletion.
        if not((GLEntry."Document No." = 'WIP0034958') and (GLEntry."G/L Account No." = '16000') and (GLEntry."Debit Amount" = 75000))then begin
            Error('The Entry No. = 0 record does not match the expected orphan (Doc WIP0034958 / Account 16000 / 75000). Stopping - verify manually before deleting anything.');
        end;
        if not Confirm('Delete G/L Entry, Entry No. = 0, Document WIP0034958, Amount 75000.00? This cannot be undone.', false)then exit;
        GLEntry.Delete(false);
        Message('Deleted. G/L Entry Entry No. = 0 removed.');
    end;
}
