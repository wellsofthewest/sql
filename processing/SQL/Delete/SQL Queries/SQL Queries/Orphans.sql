--Look for states from mv tables not in state_lineage
SELECT * FROM sde.sde_mvtables_modified WHERE state_id NOT IN (SELECT lineage_id FROM sde.sde_state_lineages);

--Look for states from sde.states not in state_lineage
SELECT * FROM sde.sde_states WHERE state_id NOT IN (SELECT lineage_id FROM sde.sde_state_lineages);

--Look for states not in lineage from lineage_name
SELECT * FROM sde.sde_states WHERE lineage_name NOT IN (SELECT lineage_name FROM sde.sde_state_lineages);

--Look for state id's in mvtables not in states
SELECT * FROM sde.sde_mvtables_modified WHERE state_id NOT IN (SELECT state_id FROM sde.sde_states);

--Look for state_id and parent states not in sde.states
select state_id from sde.sde_states where parent_state_id not in (select state_id from sde.sde_states) order by state_id;

--Look for distinct state id's not in lineage name not in state_lineages
select distinct state_id from sde.sde_states where lineage_name not in (select lineage_name from sde.sde_state_lineages) order by state_id;

--Look for distinct state id's not in state_lineage
select distinct state_id from sde.sde_states where state_id not in (select lineage_id from sde.sde_state_lineages) order by state_id;

--Look lineage_id's not in sde.states
select lineage_id from sde.sde_state_lineages where lineage_id not in (select state_id from sde.sde_states);

--Look for state id's from mv_tables not in sde.states
select state_id from sde.sde_mvtables_modified where state_id not in (select state_id from sde.sde_states);

1:13 PM

a) Check for Incomplete or missing lineages: 

select state_id from sde.sde_states ST where not exists 
(select * from sde.sde_state_lineages SL 
where ST.lineage_name = SL.lineage_name and SL.lineage_id = 0); 

b) Check for Invalid parent state ids: 

select state_id from sde.sde_states where parent_state_id not in 
(select state_id from sde.sde_states) 
order by state_id; 

c) Check for States with no lineages: 

select distinct state_id from sde.sde_states where lineage_name not in 
(select lineage_name from sde.sde_state_lineages) 
order by state_id; 

d) Check Lineages missing states: 

select distinct state_id from sde.sde_states where state_id not in 
(select lineage_id from sde.sde_state_lineages) 
order by state_id; 

e) Check for edits with state_ids that have no parent: 

Select state_id from sde.sde_MVTABLES_MODIFIED 
where state_id in (select state_id from sde.sde_states where parent_state_id not in 
(select state_id from sde.sde_states)) 
