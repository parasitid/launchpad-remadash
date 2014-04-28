import groovy.json.JsonSlurper
import groovy.json.JsonOutput

def allSpecs = new JsonSlurper().parseText( new URL("https://api.launchpad.net/devel/solum/all_specifications").text )


allSpecs.entries.collect{ /*findAll{ it.definition_status == "Approved" }.collect{ */
  [
	priority:it.priority, 
	title:it.title, 
	isComplete:it.is_complete, 
	isStarted: it.is_started, 
        dateStarted:it.date_started,
        dateCompleted:it.date_completed,
	milestone: it.milestone_link?.substring(it.milestone_link?.lastIndexOf('/')),
	assignee: it.assignee_link?.substring(it.assignee_link?.lastIndexOf('/'))
 ]
  
}.groupBy{ it.milestone }.each{ milestone, specs -> 
   println " ######### $milestone:"
   specs.sort{ it.priority }.collect{ "$it.priority: $it.title ( $it.assignee, started:$it.isStarted, done:$it.isComplete )" }.each { println "     "+it }
}


/*

         "starter_link": "https://api.launchpad.net/devel/~aotto",
            "linked_branches_collection_link": "https://api.launchpad.net/devel/solum/+spec/api/linked_branches",
            "lifecycle_status": "Complete",
            "title": "Solum API",
            "definition_status": "Approved",
            "milestone_link": "https://api.launchpad.net/devel/solum/+milestone/milestone-1",
            "priority": "Essential",
            "http_etag": "\"69ba724114101dfcd4f913942eb8168611be7881-5cafd0c19e98ba7a4937b8d30083b8e22eacf84f\"",
            "self_link": "https://api.launchpad.net/devel/solum/+spec/api",
            "information_type": "Public",
            "date_started": "2013-11-21T22:34:20.949638+00:00",
            "has_accepted_goal": true,
            "resource_type_link": "https://api.launchpad.net/devel/#specification",
            "completer_link": "https://api.launchpad.net/devel/~aotto",
            "bugs_collection_link": "https://api.launchpad.net/devel/solum/+spec/api/bugs",
            "is_started": true,
            "dependencies_collection_link": "https://api.launchpad.net/devel/solum/+spec/api/dependencies",
            "specification_url": "https://wiki.openstack.org/wiki/Solum/API",
            "assignee_link": "https://api.launchpad.net/devel/~aotto",
            "target_link": "https://api.launchpad.net/devel/solum",
            "direction_approved": true,
            "workitems_text": "",
            "date_completed": "2014-04-01T16:22:41.981924+00:00",
            "name": "api",
            "web_link": "https://blueprints.launchpad.net/solum/+spec/api",
            "summary": "Specify the API service for Solum user interfaces to consume, including the CLI tools, Horizon, IDE Plugins, etc.",
            "owner_link": "https://api.launchpad.net/devel/~aotto",
            "approver_link": "https://api.launchpad.net/devel/~aotto",
            "drafter_link": "https://api.launchpad.net/devel/~aotto",
            "date_created": "2013-10-01T01:29:27.357395+00:00",
            "is_complete": true,


*/
