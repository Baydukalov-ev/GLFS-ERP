
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СформироватьОтчет(ПолучитьИзВременногоХранилища(Параметры.ДанныеДляФормированияОтчета));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьСкидки(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма);
	ПоказатьВопрос(Оповещение, "Обновить скидки в заказе магазина?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет(ДанныеДляФормированияОтчета)
	
	МакетРасчетСкидок = Документы.ЗаказКлиента.ПолучитьМакет("бг_РасчетСкидокРозничногоПокупателя");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ОбластьШапка = МакетРасчетСкидок.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.Заполнить(ДанныеДляФормированияОтчета.ДанныеШапки);
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	ТабличныйДокумент.Вывести(МакетРасчетСкидок.ПолучитьОбласть("ШапкаТаблицы"));
	
	Для Каждого СтрокаТовары Из ДанныеДляФормированияОтчета.Товары Цикл
		ОбластьСтрока = МакетРасчетСкидок.ПолучитьОбласть("Строка");
		ОбластьСтрока.Параметры.Заполнить(СтрокаТовары);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ОбластьИтоги = МакетРасчетСкидок.ПолучитьОбласть("Итого");
	ОбластьИтоги.Параметры.Заполнить(ДанныеДляФормированияОтчета.ДанныеПодвала.ИтогиДоПересчета);
	ОбластьИтоги.Параметры.Заполнить(ДанныеДляФормированияОтчета.ДанныеПодвала.ИтогиМагазина);
	ОбластьИтоги.Параметры.Заполнить(ДанныеДляФормированияОтчета.ДанныеПодвала.ИтогиПослеПересчета);
	ТабличныйДокумент.Вывести(ОбластьИтоги);
	
	Результат.Вывести(ТабличныйДокумент);
	
КонецПРоцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		бг_ОбновитьСкидкиВЗаказеМагазина = Истина;
	Иначе
		бг_ОбновитьСкидкиВЗаказеМагазина = Ложь;
	КонецЕсли;
	
	ЭтаФорма.Закрыть(Новый Структура("ОбновнитьСкидкиВЗаказе, ОбновитьСкидкиВЗаказеМагазина", 
													Истина, бг_ОбновитьСкидкиВЗаказеМагазина));
	
КонецПроцедуры

#КонецОбласти
