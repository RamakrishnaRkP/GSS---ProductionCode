page 60175 "AppEntries-Update Notified"
{
    PageType = API;
    Caption = 'ApprovalEntries_Update';
    APIPublisher = 'GSS';
    APIGroup = 'ApprovalEntries_Update';
    APIVersion = 'v1.0';
    EntityName = 'ApprovalEntries_Update';
    EntitySetName = 'ApprovalEntries_Update';
    SourceTable = "Approval Entry";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    Permissions = tabledata "Approval Entry"=RIMD;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Entry_No; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Document_No; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Approval_Comment; Rec.Approval_Comment)
                {
                    ApplicationArea = All;
                }
                field(Last_Modified_User_ID; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
                field(Notified; Rec.Notified)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnModifyRecord(): Boolean var
        AppEntryRec: Record "Approval Entry";
        PORec: Record "Purchase Header";
        ResRec: Record "Restricted Record";
        SORec: Record "Sales Header";
        JobRec: Record Job;
        RecRef: RecordRef;
    begin
        if Rec.Status = Rec.Status::Approved then begin
            AppEntryRec.Reset();
            AppEntryRec.SetRange("Record ID to Approve", Rec."Record ID to Approve");
            AppEntryRec.SetFilter("Entry No.", '%1', Rec."Entry No." + 1);
            if AppEntryRec.FindFirst()then begin
                if AppEntryRec.Status = AppEntryRec.Status::Created then begin
                    AppEntryRec.Validate(Status, AppEntryRec.Status::Open);
                    AppEntryRec.Modify(true);
                end;
            end
            else
            begin
                PORec.Reset();
                PORec.SetRange("No.", Rec."Document No.");
                if PORec.FindFirst()then begin
                    if Rec.Status = Rec.Status::Approved then begin
                        PORec.Validate(Status, PORec.Status::Released);
                        PORec.Modify(true);
                    end;
                    ResRec.Reset();
                    ResRec.SetRange("Record ID", PORec.RecordId);
                    if ResRec.FindSet()then repeat ResRec.Delete();
                        until ResRec.Next() = 0;
                end;
                SORec.Reset();
                SORec.SetRange("No.", Rec."Document No.");
                if SORec.FindFirst()then begin
                    if Rec.Status = Rec.Status::Approved then begin
                        SORec.Validate(Status, SORec.Status::Released);
                        SORec.Modify(true);
                    end;
                    ResRec.Reset();
                    ResRec.SetRange("Record ID", SORec.RecordId);
                    if ResRec.FindSet()then repeat ResRec.Delete();
                        until ResRec.Next() = 0;
                end;
                if Rec."Table ID" = 167 then begin
                    RecRef.Get(Rec."Record ID to Approve");
                    RecRef.SetTable(JobRec);
                    if Rec.Status = Rec.Status::Approved then begin
                        JobRec.Validate(GSSStatus, JobRec.GSSStatus::Released);
                        JobRec.Modify(true);
                    end;
                    ResRec.Reset();
                    ResRec.SetRange("Record ID", JobRec.RecordId);
                    if ResRec.FindSet()then repeat ResRec.Delete();
                        until ResRec.Next() = 0;
                end;
            end;
        end
        else
        begin
            if Rec.Status = Rec.Status::Rejected then begin
                AppEntryRec.Reset();
                AppEntryRec.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                AppEntryRec.SetFilter("Due Date", '=%1', Rec."Due Date");
                AppEntryRec.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
                if AppEntryRec.FindSet()then repeat AppEntryRec.Status:=AppEntryRec.Status::Rejected;
                        AppEntryRec.Modify(true);
                    until AppEntryRec.Next() = 0;
                PORec.Reset();
                PORec.SetRange("No.", Rec."Document No.");
                if PORec.FindFirst()then begin
                    PORec.Validate(Status, PORec.Status::Open);
                    PORec.Modify(true);
                    ResRec.Reset();
                    ResRec.SetRange("Record ID", PORec.RecordId);
                    if ResRec.FindSet()then repeat ResRec.Delete();
                        until ResRec.Next() = 0;
                end;
                SORec.Reset();
                SORec.SetRange("No.", Rec."Document No.");
                if SORec.FindFirst()then begin
                    SORec.Validate(Status, SORec.Status::Open);
                    SORec.Modify(true);
                    ResRec.Reset();
                    ResRec.SetRange("Record ID", SORec.RecordId);
                    if ResRec.FindSet()then repeat ResRec.Delete();
                        until ResRec.Next() = 0;
                end;
                if Rec."Table ID" = 167 then begin
                    RecRef.Get(Rec."Record ID to Approve");
                    RecRef.SetTable(JobRec);
                    JobRec.Validate(GSSStatus, JobRec.GSSStatus::Open);
                    JobRec.Modify(true);
                    ResRec.Reset();
                    ResRec.SetRange("Record ID", JobRec.RecordId);
                    if ResRec.FindSet()then repeat ResRec.Delete();
                        until ResRec.Next() = 0;
                end;
            end;
        end;
    end;
}
