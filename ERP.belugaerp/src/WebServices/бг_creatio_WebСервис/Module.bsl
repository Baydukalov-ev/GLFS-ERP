
#Область ОбработчикиWebСервиса

#Область Справочники

Функция CreatePartner(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreatePartner'"));
	Возврат бг_creatio_Интеграция.СоздатьКлиента(Input);
	
КонецФункции

Функция UpdatePartnersInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdatePartnersInCRM'"));
	Возврат бг_creatio_Интеграция.ОбновитьКлиентовВCreatio(Input);
	
КонецФункции

Функция UpdatePartnersAddressesInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdatePartnersAddressesInCRM'"));
	Возврат бг_creatio_Интеграция.ОбновитьАдресаКлиентовВCreatio(input);
	
КонецФункции

Функция UpdateBankAccountsInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdateBankAccountsInCRM'"));
	Возврат бг_creatio_Интеграция.ОбновитьБанковскиеСчетаВCreatio(Input);
	
КонецФункции

Функция UpdateContractsInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdateContractsInCRM'"));
	Возврат бг_creatio_Интеграция.ОбновитьКонтрактыВCreatio(Input);
	
КонецФункции

Функция UpdateLicensesInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdateLicensesInCRM'"));
	Возврат бг_creatio_Интеграция.ОбновитьЛицензииВCreatio(Input);
	
КонецФункции

Функция UpdateUnloadingPointInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdateUnloadingPointInCRM'"));
	Возврат бг_creatio_Интеграция.ОбновитьПунктыРазгрузкиВCreatio(Input);
	
КонецФункции

Функция UpdatePartnerIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdatePartnerIn1C'"));
	Возврат бг_creatio_Интеграция.ОбновитьКлиента(Input);
	
КонецФункции

Функция UpdateAddressIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdateAddressIn1C'"));
	Возврат бг_creatio_Интеграция.ОбновитьАдресКлиента(Input);
	
КонецФункции

Функция CreateUpdateBankAccountIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateUpdateBankAccountIn1C'"));
	Возврат бг_creatio_Интеграция.СоздатьОбновитьБанковскийСчетКлиента(Input);
	
КонецФункции

Функция CreateUpdateContractIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateUpdateContractIn1C'"));
	Возврат бг_creatio_Интеграция.СоздатьОбновитьДоговорКлиента(Input);
	
КонецФункции

Функция CreateUpdateLicenseIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateUpdateLicenseIn1C'"));
	Возврат бг_creatio_Интеграция.СоздатьОбновитьЛицензиюКлиента(Input);
	
КонецФункции

Функция CreateUpdateCommercialTermsIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateUpdateCommercialTermsIn1C'"));
	Возврат бг_creatio_Интеграция.СоздатьОбновитьСкидкиКлиента(Input);
	
КонецФункции

Функция CreateUpdateUnloadingPointIn1C(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateUpdateUnloadingPointIn1C'"));
	Возврат бг_creatio_Интеграция.СоздатьОбновитьПунктыНазначенияКлиента(Input);
	
КонецФункции

Функция UpdateExchangeResults(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'UpdateExchangeResults'"));
	Возврат бг_creatio_Интеграция.ОбновитьСтатусОбмена(Input);
	
КонецФункции

#КонецОбласти

#Область Заказы

Функция CreateOrder(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateOrder'"));
	Возврат бг_creatio_Интеграция.СоздатьЗаказ(Input);
	
КонецФункции

Функция CreateUpdateOrderInCRM(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'CreateUpdateOrderInCRM'"));
	Возврат бг_creatio_Интеграция.СоздатьОбновитьЗаказыВCreatio(Input);
	
КонецФункции

#КонецОбласти

#Область ЦеныОстатки

Функция GetOrderPrices(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'GetOrderPrices'"));
	Возврат бг_creatio_Интеграция.ЦеныТоваровПоЗаказу(Input);
	
КонецФункции

Функция GetOrderSKUBalance(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'GetOrderSKUBalance'"));
	Возврат бг_creatio_Интеграция.ОстаткиТоваровПоЗаказу(Input);
	
КонецФункции

Функция GetAllPrices(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'GetAllPrices'"));
	Возврат бг_creatio_Интеграция.ЦеныТоваров(Input);
	
КонецФункции

Функция GetTotalSKUBalance(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'GetTotalSKUBalance'"));
	Возврат бг_creatio_Интеграция.ОстаткиТоваров(Input);
	
КонецФункции

Функция GetDebt(Input)
	
	бг_creatio_Интеграция.ЗарегистрироватьВызовМетода(НСтр("ru = 'GetDebt'"));
	Возврат бг_creatio_Интеграция.ДебиторскаяЗадолженность(Input);
	
КонецФункции

#КонецОбласти

#Область НеИспользуемые

Функция CreateUpdateClientGroupInCRM(Input)
	
	Возврат бг_creatio_Интеграция.СоздатьОбновитьГруппыКлиентовВCreatio_УПП(Input);
	
КонецФункции

Функция CreateUpdateOKOPFInCRM(Input)
	
	Возврат бг_creatio_Интеграция.СоздатьОбновитьОКОПФВCreatio_УПП(Input);
	
КонецФункции

Функция CreateUpdateStorageInCRM(Input)
	
	Возврат  бг_creatio_Интеграция.СоздатьОбновитьСкладыВCreatio_УПП(Input);
	
КонецФункции

Функция UpdateBanksInCRM(Input)
	
	Возврат  бг_creatio_Интеграция.ОбновитьБанкиВCreatio_УПП(Input);
	
КонецФункции

#КонецОбласти // НеИспользуемые

#КонецОбласти // ОбработчикиWebСервиса