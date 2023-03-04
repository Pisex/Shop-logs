#pragma semicolon 1
#include <sourcemod>
#include <shop>

#pragma newdecls required

public Plugin myinfo =
{
	name = "[Shop] Logs",
	author = "Pisex",
	version = "1.1",
	url = "Discord => Pisex#0023"
};

stock const char g_sLogFile[] = "addons/sourcemod/logs/shop_log.log";

ConVar
hCreditsTransfer,
hCreditsGive,
hCreditsSet,
hCreditsTake,
hItemTransfer,
hItemBuy,
hItemSell,
hItemElapsed;

public void OnPluginStart()
{
	hCreditsTransfer = CreateConVar("sm_sl_cred_trans", "1", "Хотите ли логировать передачу кредитов");
	
	hCreditsGive = CreateConVar("sm_sl_cred_give", "1", "Хотите ли логировать выдачу кредитов");
	
	hCreditsSet = CreateConVar("sm_sl_cred_set", "1", "Хотите ли логировать установку кредитов");
	
	hCreditsTake = CreateConVar("sm_sl_cred_take", "1", "Хотите ли логировать отнятие кредитов");
	
	hItemTransfer = CreateConVar("sm_sl_item_trans", "1", "Хотите ли логировать передачу предметов");
	
	hItemBuy = CreateConVar("sm_sl_item_buy", "1", "Хотите ли логировать покупку предметов");
	
	hItemSell = CreateConVar("sm_sl_item_sell", "1", "Хотите ли логировать продажу предметов");
	
	hItemElapsed = CreateConVar("sm_sl_item_elapsed", "1", "Хотите ли логировать истечение предмета");
	
	AutoExecConfig(true, "shop_logs", "shop");
}


public void Shop_OnItemTransfered(int client, int target, ItemId item_id)
{
	char sCategory[64];
	
	if(Shop_GetCategoryById(Shop_GetItemCategoryId(item_id), sCategory, sizeof(sCategory)) && hItemTransfer.BoolValue && client > 0 && target > 0)
	{
		char sItemName[64];
		Shop_GetItemNameById(item_id, sItemName, sizeof sItemName);
		LogToFile(g_sLogFile, "Игрок %L передал предмет %i (%s) (из категории: %s) игроку %L", client, item_id, sItemName, sCategory, target);
	}
}

public void Shop_OnCreditsTransfered(int client, int target, int amount_give, int amount_remove)
{
	if(hCreditsTransfer.BoolValue && client > 0 && target > 0) LogToFile(g_sLogFile, "Игрок %L передал %i (из %i) кредитов игроку %L", client, amount_give, amount_remove, target);
}

public Action Shop_OnCreditsGiven(int client, int &amount, int by_who)
{
	if(hCreditsGive.BoolValue && by_who > 0 && client > 0) LogToFile(g_sLogFile, "Игрок %L получил %i кредитов от игрока %L", client, amount, by_who);
	return Plugin_Continue;
}

public Action Shop_OnCreditsTaken(int client, int &amount, int by_who)
{
	if(hCreditsTake && by_who > 0 && client > 0) LogToFile(g_sLogFile, "Игрок %L отнял %i кредитов у игрока %L", by_who, amount, client);
	return Plugin_Continue;
}

public Action Shop_OnCreditsSet(int client, int &amount, int by_who)
{
	if(hCreditsSet.BoolValue && by_who > 0 && client > 0) LogToFile(g_sLogFile, "Игрок %L установил %i кредитов игроку %L", by_who, amount, client);
	return Plugin_Continue;
}

public Action Shop_OnItemBuy(int client, CategoryId category_id, const char[] category, ItemId item_id, const char[] item, ItemType type, int &price, int &sell_price, int &value)
{
	if(hItemBuy.BoolValue && client > 0)
	{
		char sItemName[64],
		 sCategoryName[64];
		Shop_GetCategoryNameById(category_id, sCategoryName, sizeof sCategoryName);
		Shop_GetItemNameById(item_id, sItemName, sizeof sItemName);
		LogToFile(g_sLogFile, "Игрок %L купил предмет %i (%s) (из категории: %s) за %i кредитов", client, item_id, sItemName, sCategoryName, price);
	}
	return Plugin_Continue;
}

public Action Shop_OnItemSell(int client, CategoryId category_id, const char[] category, ItemId item_id, const char[] item, ItemType type, int &sell_price, int &gold_sell_price)
{
	if(hItemSell.BoolValue && client > 0)
	{
		char sItemName[64],
			 sCategoryName[64];
		Shop_GetCategoryNameById(category_id, sCategoryName, sizeof sCategoryName);
		Shop_GetItemNameById(item_id, sItemName, sizeof sItemName);
		LogToFile(g_sLogFile, "Игрок %L продал предмет %i (%s) (из категории: %s) за %i кредитов", client, item_id, sItemName, sCategoryName, sell_price);
	}
	return Plugin_Continue;
}

public void Shop_OnItemElapsed(int client, CategoryId category_id, const char[] category, ItemId item_id, const char[] item)
{
	if(hItemElapsed.BoolValue && client > 0)
	{
		char sItemName[64],
			 sCategoryName[64];
		Shop_GetCategoryNameById(category_id, sCategoryName, sizeof sCategoryName);
		Shop_GetItemNameById(item_id, sItemName, sizeof sItemName);
		LogToFile(g_sLogFile, "У игрока %L истёк предмет %i (%s) (из категории: %s)", client, item_id, sItemName, sCategoryName);
	
	}
}