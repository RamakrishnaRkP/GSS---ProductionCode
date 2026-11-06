page 60177 "GL Recovery Staging"
{
    ApplicationArea = All;
    Caption = 'G/L Recovery Staging';
    PageType = List;
    SourceTable = "GL Recovery Staging";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                }
                field("Orig. Entry No."; Rec."Orig. Entry No.")
                {
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("Source Currency Code"; Rec."Source Currency Code")
                {
                }
                field("Source Currency Amount"; Rec."Source Currency Amount")
                {
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                }
                field("Add.-Currency Debit Amount"; Rec."Add.-Currency Debit Amount")
                {
                }
                field("Add.-Currency Credit Amount"; Rec."Add.-Currency Credit Amount")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Row Inserted"; Rec."Row Inserted")
                {
                }
                field("New Entry No."; Rec."New Entry No.")
                {
                }
                field("Error Text"; Rec."Error Text")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(InsertGLEntries)
            {
                ApplicationArea = All;
                Caption = 'Insert G/L Entries (Direct)';
                Image = Post;
                ToolTip = 'Inserts staged rows directly into G/L Entry, preserving Transaction No. and Dimension Set ID. No other table is touched.';

                trigger OnAction()
                var
                    GLRecoveryMgt: Codeunit "GL Recovery Mgt.";
                    Confirmed: Boolean;
                begin
                    if not Confirm('This will insert %1 new rows directly into G/L Entry, bypassing normal posting. Continue?', false, Rec.Count())then exit;
                    GLRecoveryMgt.InsertGLEntriesFromStaging();
                end;
            }
            action(CleanupStrayZero)
            {
                ApplicationArea = All;
                Caption = 'Delete Stray Entry No. 0';
                Image = Delete;

                trigger OnAction()
                var
                    GLRecoveryMgt: Codeunit "GL Recovery Mgt.";
                begin
                    GLRecoveryMgt.DeleteStrayZeroEntry();
                end;
            }
        }
    }
}
