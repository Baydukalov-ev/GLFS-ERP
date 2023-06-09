&Вместо("ОписанияИспользованияРеквизитовСерии")
Функция бг_ОписанияИспользованияРеквизитовСерии(НастройкиИспользованияСерий = Неопределено, ПараметрыУказанияСерий = Неопределено, ЗначенияПолейСвязи = Неопределено) Экспорт

	ОписанияИспользованияРеквизитовСерии = ПродолжитьВызов(НастройкиИспользованияСерий, ПараметрыУказанияСерий, ЗначенияПолейСвязи);
	
	ЭтоФСМ = НастройкиИспользованияСерий.ВидНоменклатуры = бг_КонстантыПовтИсп.ЗначениеКонстанты("ФедеральнаяСпецМарка");
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_СерияМарки";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_СерияМарки.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьСериюМарки";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_СерияМарки%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование       = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_НомерРулона";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_НомерРулона.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьНомерРулона";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_НомерРулона%';|en = '%бг_НомерРулона%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_НомерДиапазонаВРулоне";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_НомерДиапазонаВРулоне.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьНомерДиапазонаВРулоне";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_НомерДиапазонаВРулоне%';|en = '%бг_НомерДиапазонаВРулоне%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_НачальныйНомерДиапазона";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_НачальныйНомерДиапазона.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьНачальныйНомерДиапазона";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_НачальныйНомерДиапазона%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование       = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_КонечныйНомерДиапазона";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_КонечныйНомерДиапазона.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьКонечныйНомерДиапазона";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_КонечныйНомерДиапазона%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование       = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_ЗаявлениеОВыдачеФСМ";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_ЗаявлениеОВыдачеФСМ.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьЗаявлениеОВыдачеФСМ";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_ЗаявлениеОВыдачеФСМ%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование       = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	ОписаниеИспользованиеРеквизитаСерии = ОписаниеИспользованиеРеквизитаСерии();
	ОписаниеИспользованиеРеквизитаСерии.ИмяРеквизита = "бг_НакладнаяНаВыдачуФСМ";
	ОписаниеИспользованиеРеквизитаСерии.ПредставлениеРеквизита
		= Метаданные.Справочники.СерииНоменклатуры.Реквизиты.бг_НакладнаяНаВыдачуФСМ.Представление();
	ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки = "бг_ИспользоватьНакладнаяНаВыдачуФСМ";
	ОписаниеИспользованиеРеквизитаСерии.ТекстШаблонаНаименования = НСтр("ru = '%бг_НакладнаяНаВыдачуФСМ%'");
	ОписаниеИспользованиеРеквизитаСерии.Использование       = НастройкиИспользованияСерий[ОписаниеИспользованиеРеквизитаСерии.ИмяНастройки];
	ОписаниеИспользованиеРеквизитаСерии.ПроверятьЗаполнение = ЭтоФСМ;
	ОписанияИспользованияРеквизитовСерии.Добавить(ОписаниеИспользованиеРеквизитаСерии);
	
	Возврат ОписанияИспользованияРеквизитовСерии;

КонецФункции

&Вместо("РеквизитыНастройкиУказанияСерий")
Функция бг_РеквизитыНастройкиУказанияСерий()
	
	РеквизитыНастройкиУказанияСерий = ПродолжитьВызов();
	
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьСериюМарки");
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьНомерРулона");
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьНомерДиапазонаВРулоне");
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьНачальныйНомерДиапазона");
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьКонечныйНомерДиапазона");
	
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьЗаявлениеОВыдачеФСМ");
	РеквизитыНастройкиУказанияСерий.Добавить("бг_ИспользоватьНакладнаяНаВыдачуФСМ");
	
	Возврат РеквизитыНастройкиУказанияСерий;
	
КонецФункции

