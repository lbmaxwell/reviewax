BEGIN; -- Corresponds to COMMIT at end

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person1@domain.com', 'Lastname1', 'Firstname1', first_app_user_id(), first_app_user_id());

INSERT INTO app_user (name, person_id, created_by, updated_by)
VALUES('userp1', last_person_id(), first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person2@domain.com', 'Lastname2', 'Firstname2', first_app_user_id(), first_app_user_id());

INSERT INTO app_user (name, person_id, created_by, updated_by)
VALUES('userp2', last_person_id(), first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person3@domain.com', 'Lastname3', 'Firstname3', first_app_user_id(), first_app_user_id());

INSERT INTO app_user (name, person_id, created_by, updated_by)
VALUES('userp3', last_person_id(), first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person4@domain.com', 'Lastname4', 'Firstname4', first_app_user_id(), first_app_user_id());

INSERT INTO app_user (name, person_id, created_by, updated_by)
VALUES('userp4', last_person_id(), first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person5@domain.com', 'Lastname5', 'Firstname5', first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person6@domain.com', 'Lastname6', 'Firstname6', first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person7@domain.com', 'Lastname7', 'Firstname7', first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person8@domain.com', 'Lastname8', 'Firstname8', first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person9@domain.com', 'Lastname9', 'Firstname9', first_app_user_id(), first_app_user_id());

INSERT INTO person (email, last_name, first_name, created_by, updated_by)
VALUES ('person10@domain.com', 'Lastname10', 'Firstname10', first_app_user_id(), first_app_user_id());

INSERT INTO organization(name, created_by, updated_by)
VALUES ('West Virginia', first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Microsoft Dynamics', 'Primary accounting and GL system',
  first_app_user_id(), first_app_user_id())   ;

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Blue World', 'Project time and expense tracking', first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Docklink', 'AP workflow and approvals', first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO organization(name, created_by, updated_by)
VALUES ('Texas - Energy', first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Quickbooks - Energy', 'Primary accounting and GL system for subsidiary',
  first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
  VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Time & Billing Primary Branch', 'Project time and expense tracking',
  first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO organization(name, created_by, updated_by)
VALUES ('Texas - Survey', first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Quickbooks - Survey', 'Primary accounting and GL system for subsidiary',
  first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
  VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

INSERT INTO system(name, description, created_by, updated_by)
VALUES ('Survey Project Tracking', 'Project time, equipment, and expense tracking',
  first_app_user_id(), first_app_user_id());

INSERT INTO system_organization(system_id, organization_id, created_by, updated_by)
VALUES(last_system_id(), last_organization_id(), first_app_user_id(), first_app_user_id());

COMMIT;
