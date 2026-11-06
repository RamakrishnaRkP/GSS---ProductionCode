codeunit 60105 GSSApprovalMgt
{
    procedure IsJobApprovalsWorkflowEnabled(var Job: Record Job): Boolean begin
        exit(WorkflowManagement.CanExecuteWorkflow(Job, RunWorkflowOnSendJobDocForApprovalCode));
    end;
    procedure CheckJobApprovalPossible(var Job: Record Job): Boolean begin
        if not IsJobApprovalsWorkflowEnabled(Job)then Error(NoWorkflowEnabledErr);
        if not Job.JobPlanningLineExist()then Error(NothingToApproveErr);
        OnAfterCheckJobApprovalPossible(Job);
        exit(true);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        Job: Record Job;
        JobDocClass: Codeunit "GSSJob Document Class";
    begin
        case RecRef.Number of Database::Job: begin
            RecRef.SetTable(Job);
            JobDocClass.SetStatusToPendingApproval(Job);
            Variant:=Job;
            IsHandled:=true;
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Job: Record Job;
        JobDocClass: Codeunit "GSSJob Document Class";
    begin
        case RecRef.Number of Database::Job: begin
            RecRef.SetTable(Job);
            JobDocClass.Reopen(Job);
            Handled:=true;
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Job: Record Job;
        JobDocClass: Codeunit "GSSJob Document Class";
    begin
        case RecRef.Number of Database::Job: begin
            RecRef.SetTable(Job);
            JobDocClass.Release(Job);
            Handled:=true;
        end;
        end;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckJobApprovalPossible(var Job: Record Job)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnSendJobDocumentForApproval(var Job: Record Job)
    begin
    end;
    [IntegrationEvent(false, false)]
    procedure OnCancelJobApprovalRequest(var Job: Record Job)
    begin
    end;
    procedure IsJobPendingApproval(var Job: Record Job): Boolean begin
        if Job.GSSStatus <> Job.GSSStatus::Open then exit(false);
        exit(IsJobApprovalsWorkflowEnabled(Job));
    end;
    procedure RunWorkflowOnSendJobDocForApprovalCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnSendJobDocumentForApproval'));
    end;
    procedure RunWorkflowOnCancelJobApprovalRequestCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnCancelJobDocumentApprovalRequest'));
    end;
    procedure RunWorkflowOnAfterReleaseJobDocCode(): Code[128]begin
        exit(UpperCase('RunWorkflowOnAfterReleaseJobDocument'));
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::GSSApprovalMgt, 'OnSendJobDocumentForApproval', '', false, false)]
    local procedure RunWorkflowOnSendItemJournalLineForApproval(var Job: Record Job)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendJobDocForApprovalCode(), Job);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::GSSApprovalMgt, 'OnCancelJobApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnCancelJobApprovalRequest(var Job: Record Job)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelJobApprovalRequestCode(), Job);
    end;
    #region WorkflowEventHandling
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure ATSHIP_OnAddWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendJobDocForApprovalCode(), Database::Job, JobDocumentSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelJobApprovalRequestCode(), Database::Job, JobDocumentApprovalRequestCancelEventDescTxt, 0, false);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure ATSHIP_OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of RunWorkflowOnCancelJobApprovalRequestCode: WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelJobApprovalRequestCode, RunWorkflowOnSendJobDocForApprovalCode());
        WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode: WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendJobDocForApprovalCode());
        WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode: WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendJobDocForApprovalCode());
        WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode: WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendJobDocForApprovalCode());
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
    local procedure ATSHIP_OnAddWorkflowTableRelationsToLibrary()
    var
        WorkflowTableRel: Record "Workflow - Table Relation";
        ApprovalEntry: Record "Approval Entry";
        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(Database::Job, 1, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of WorkflowResponseHandling.SetStatusToPendingApprovalCode(): begin
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendJobDocForApprovalCode());
        end;
        WorkflowResponseHandling.CreateApprovalRequestsCode(): begin
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, RunWorkflowOnSendJobDocForApprovalCode());
        end;
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode(): begin
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnSendJobDocForApprovalCode());
        end;
        WorkflowResponseHandling.ReleaseDocumentCode(): begin
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode, RunWorkflowOnSendJobDocForApprovalCode());
        end;
        WorkflowResponseHandling.RejectAllApprovalRequestsCode(): begin
        end;
        WorkflowResponseHandling.OpenDocumentCode(): begin
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, RunWorkflowOnCancelJobApprovalRequestCode());
        end;
        WorkflowResponseHandling.CancelAllApprovalRequestsCode(): begin
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, RunWorkflowOnCancelJobApprovalRequestCode());
        end;
        end end;
    #endregion 
    var WorkflowManagement: Codeunit "Workflow Management";
    ApprovalsMgt: Codeunit "Approvals Mgmt.";
    NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
    NothingToApproveErr: Label 'There is nothing to approve.';
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    JobDocumentSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a job document is requested.';
    JobDocumentApprovalRequestCancelEventDescTxt: TextConst ENU = 'An approval request for a job document is canceled.';
}
