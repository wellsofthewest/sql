SDE schema:
SELECT STATE_ID from sde.sde_states WHERE STATE_ID not IN (SELECT lineage_id FROM sde.sde_state_lineages)
SELECT lineage_name from sde.sde_states WHERE lineage_name not IN (SELECT lineage_name FROM sde.sde_state_lineages)
SELECT STATE_ID from sde.sde_mvtables_modified WHERE STATE_ID not IN (SELECT lineage_id FROM sde.sde_state_lineages)
SELECT STATE_ID from sde.sde_mvtables_modified WHERE STATE_ID not IN (SELECT STATE_ID FROM sde.sde_states)
select STATE_ID from sde.sde_states where parent_State_ID not in (select STATE_ID from sde.sde_states) order by State_ID
select distinct STATE_ID from sde.sde_states where lineage_name not in (select lineage_name from sde.sde_state_lineages) order by State_ID
select distinct STATE_ID from sde.sde_states where STATE_ID not in (select lineage_id from sde.sde_state_lineages) order by State_ID
select lineage_id from sde.sde_state_lineages where lineage_id not in (select STATE_ID from sde.sde_states)
 
DBO schema:
SELECT STATE_ID from dbo.sde_states WHERE STATE_ID not IN (SELECT lineage_id FROM dbo.sde_state_lineages)
SELECT lineage_name from dbo.sde_states WHERE lineage_name not IN (SELECT lineage_name FROM dbo.sde_state_lineages)
SELECT STATE_ID from dbo.sde_mvtables_modified WHERE STATE_ID not IN (SELECT lineage_id FROM dbo.sde_state_lineages)
SELECT STATE_ID from dbo.sde_mvtables_modified WHERE STATE_ID not IN (SELECT STATE_ID FROM dbo.sde_states)
select STATE_ID from dbo.sde_states where parent_State_ID not in (select STATE_ID from dbo.sde_states) order by State_ID
select distinct STATE_ID from dbo.sde_states where lineage_name not in (select lineage_name from dbo.sde_state_lineages) order by State_ID
select distinct STATE_ID from dbo.sde_states where STATE_ID not in (select lineage_id from dbo.sde_state_lineages) order by State_ID
select lineage_id from dbo.sde_state_lineages where lineage_id not in (select STATE_ID from dbo.sde_states)
