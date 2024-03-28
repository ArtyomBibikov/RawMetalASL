state("Raw Metal") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Raw Metal";
	vars.Helper.LoadSceneManager = true;
	
	settings.Add("RM", true, "Raw Metal");
		settings.Add("ANYAL", true, "Any% All Levels", "RM");
			settings.Add("L1F1", true, "L1F1", "ANYAL");
			settings.Add("L1F2", true, "L1F2", "ANYAL");
			settings.Add("L1F3", true, "L1F3", "ANYAL");
			settings.Add("L1FB", true, "L1FB", "ANYAL");
			settings.Add("L2F1", true, "L2F1", "ANYAL");
			settings.Add("L2F2", true, "L2F2", "ANYAL");
			settings.Add("L2F3", true, "L2F3", "ANYAL");
			settings.Add("L2FB", true, "L2FB", "ANYAL");
			settings.Add("L3F1", true, "L3F1", "ANYAL");
			settings.Add("L3F2", true, "L3F2", "ANYAL");
			settings.Add("L3F3", true, "L3F3", "ANYAL");
			settings.Add("L3FB", true, "L3FB", "ANYAL");
			settings.Add("L4F1", true, "L4F1", "ANYAL");

	vars.Splits = new HashSet<string>();
	
	vars.Helper.AlertLoadless();
}

onStart
{
	vars.Splits.Clear();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["loading"] = mono.Make<bool>("LevelLoader", "instance", "IsLoading");
		vars.Helper["paused"] = mono.Make<bool>("GameManager", "instance", "paused");
		vars.Helper["ascending"] = mono.Make<bool>("LevelLoader", "instance", "IsAscending");
		vars.Helper["elepunch"] = mono.Make<bool>("GameManager", "instance", "player", "mitrikTimer", "stopped");
		vars.Helper["loadlvl"] = mono.MakeString("LevelLoader", "instance", "LoadingLevel");

		return true;
	});
	current.Scene = "";
}

update
{
	current.Scene = vars.Helper.Scenes.Active.Name;
}

split
{
	if (old.loadlvl != current.loadlvl && !current.ascending)
	{
		return settings[old.loadlvl] && vars.Splits.Add(old.loadlvl);
	}

	return old.elepunch != current.elepunch
		|| old.Scene != current.Scene && current.Scene == "Escape Success Screen";
}

start
{    
	return old.Scene != current.Scene && current.Scene == "Elevator";
}

reset
{
	return old.Scene != current.Scene && current.Scene == "Title Screen";
}

isLoading
{
	return current.loading || current.paused;
}
