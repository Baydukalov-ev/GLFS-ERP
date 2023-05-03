
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ОставитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		ВыгружаемыеРеквизиты());
		
	ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства);
	
КонецПроцедуры

#КонецОбласти //ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()

	ВыгружаемыеРеквизиты = Новый Массив;
	
	//Шапка документа
	ВыгружаемыеРеквизиты.Добавить("Дата");
	ВыгружаемыеРеквизиты.Добавить("Номер");
	ВыгружаемыеРеквизиты.Добавить("ПометкаУдаления");
	ВыгружаемыеРеквизиты.Добавить("Проведен");
	ВыгружаемыеРеквизиты.Добавить("Автор");
	ВыгружаемыеРеквизиты.Добавить("Валюта");
	ВыгружаемыеРеквизиты.Добавить("ВалютаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("ГруппировкаЗатрат");
	ВыгружаемыеРеквизиты.Добавить("ДатаПлатежа");
	ВыгружаемыеРеквизиты.Добавить("ДатаПоДаннымПартнера");
	ВыгружаемыеРеквизиты.Добавить("Договор");
	ВыгружаемыеРеквизиты.Добавить("ЗакупкаПодДеятельность");
	ВыгружаемыеРеквизиты.Добавить("Комментарий");
	ВыгружаемыеРеквизиты.Добавить("Контрагент");
	ВыгружаемыеРеквизиты.Добавить("Кратность");
	ВыгружаемыеРеквизиты.Добавить("Курс");
	ВыгружаемыеРеквизиты.Добавить("МаксимальныйКодСтрокиПродукция");
	ВыгружаемыеРеквизиты.Добавить("МаксимальныйНомерГруппыЗатрат");
	ВыгружаемыеРеквизиты.Добавить("Менеджер");
	ВыгружаемыеРеквизиты.Добавить("Номенклатура");
	ВыгружаемыеРеквизиты.Добавить("НомерПоДаннымПартнера");
	ВыгружаемыеРеквизиты.Добавить("ОбъектРасчетов");
	ВыгружаемыеРеквизиты.Добавить("ОплатаВВалюте");
	ВыгружаемыеРеквизиты.Добавить("Организация");
	ВыгружаемыеРеквизиты.Добавить("Партнер");
	ВыгружаемыеРеквизиты.Добавить("Подразделение");
	ВыгружаемыеРеквизиты.Добавить("ПоЗаказам");
	ВыгружаемыеРеквизиты.Добавить("ПорядокРасчетов");
	ВыгружаемыеРеквизиты.Добавить("ПроверятьУказаниеРаботы");
	ВыгружаемыеРеквизиты.Добавить("Согласован");
	ВыгружаемыеРеквизиты.Добавить("СтавкаНДС");
	ВыгружаемыеРеквизиты.Добавить("СтатьяКалькуляции");
	ВыгружаемыеРеквизиты.Добавить("Сумма");
	ВыгружаемыеРеквизиты.Добавить("СуммаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("СуммаДокумента");
	ВыгружаемыеРеквизиты.Добавить("СуммаНДС");
	ВыгружаемыеРеквизиты.Добавить("СуммаНДСВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("СуммаСНДС");
	ВыгружаемыеРеквизиты.Добавить("УслугиПоПереработке");
	ВыгружаемыеРеквизиты.Добавить("УчетСырьяПоНазначениям");
	ВыгружаемыеРеквизиты.Добавить("ХозяйственнаяОперация");
	
	//Табличная часть "Продукция"
	ВыгружаемыеРеквизиты.Добавить("Продукция.Номенклатура");
	ВыгружаемыеРеквизиты.Добавить("Продукция.КоличествоУпаковок");
	ВыгружаемыеРеквизиты.Добавить("Продукция.Количество");
	ВыгружаемыеРеквизиты.Добавить("Продукция.АналитикаУчетаНоменклатуры");
	ВыгружаемыеРеквизиты.Добавить("Продукция.НомерГруппыЗатрат");
	ВыгружаемыеРеквизиты.Добавить("Продукция.КодСтрокиПродукция");
	ВыгружаемыеРеквизиты.Добавить("Продукция.СписатьНаРасходы");
	ВыгружаемыеРеквизиты.Добавить("Продукция.СтатьяРасходов");
	ВыгружаемыеРеквизиты.Добавить("Продукция.ИдентификаторСтроки");
	
	//Табличная часть "ВозвратныеОтходы"
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.Номенклатура");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.КоличествоУпаковок");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.Количество");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.НомерГруппыЗатрат");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.АналитикаУчетаНоменклатуры");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.СтатьяКалькуляции");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.СписатьНаРасходы");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.СтатьяРасходов");
	ВыгружаемыеРеквизиты.Добавить("ВозвратныеОтходы.ИдентификаторСтроки");

	//Табличная часть "Материалы"
	ВыгружаемыеРеквизиты.Добавить("Материалы.Номенклатура");
	ВыгружаемыеРеквизиты.Добавить("Материалы.КоличествоУпаковок");
	ВыгружаемыеРеквизиты.Добавить("Материалы.Количество");
	ВыгружаемыеРеквизиты.Добавить("Материалы.АналитикаУчетаНоменклатуры");
	ВыгружаемыеРеквизиты.Добавить("Материалы.СтатьяКалькуляции");
	ВыгружаемыеРеквизиты.Добавить("Материалы.НомерГруппыЗатрат");

	//Табличная часть "Услуги"
	ВыгружаемыеРеквизиты.Добавить("Услуги.Номенклатура");
	ВыгружаемыеРеквизиты.Добавить("Услуги.Сумма");
	ВыгружаемыеРеквизиты.Добавить("Услуги.СуммаНДС");
	ВыгружаемыеРеквизиты.Добавить("Услуги.СтавкаНДС");
	ВыгружаемыеРеквизиты.Добавить("Услуги.СуммаСНДС");
	ВыгружаемыеРеквизиты.Добавить("Услуги.СтатьяКалькуляции");
	ВыгружаемыеРеквизиты.Добавить("Услуги.НомерГруппыЗатрат");
	ВыгружаемыеРеквизиты.Добавить("Услуги.АналитикаУчетаНоменклатуры");
	ВыгружаемыеРеквизиты.Добавить("Услуги.ИдентификаторСтроки");
	ВыгружаемыеРеквизиты.Добавить("Услуги.СуммаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("Услуги.СуммаНДСВзаиморасчетов");

	//Табличная часть "ВидыЗапасов"
	ВыгружаемыеРеквизиты.Добавить("ВидыЗапасов.НомерГруппыЗатрат");
	ВыгружаемыеРеквизиты.Добавить("ВидыЗапасов.ВидЗапасов");
	ВыгружаемыеРеквизиты.Добавить("ВидыЗапасов.Количество");
	ВыгружаемыеРеквизиты.Добавить("ВидыЗапасов.АналитикаУчетаНоменклатуры");
	ВыгружаемыеРеквизиты.Добавить("ВидыЗапасов.СтатьяКалькуляции");
	ВыгружаемыеРеквизиты.Добавить("ВидыЗапасов.ИдентификаторСтроки");

	//Табличная часть "РасшифровкаПлатежа"
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.Сумма");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ОбъектРасчетов");

	ВыгружаемыеРеквизиты = СтрСоединить(ВыгружаемыеРеквизиты, ",");
	
	Возврат ВыгружаемыеРеквизиты;
	
КонецФункции

Процедура ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства)

	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	// Дополнительные реквизиты ссылочных объектов
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.Номенклатура,
		"Наименование");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.СтатьиКалькуляции,
		"Наименование");
	
КонецПроцедуры

#КонецОбласти //СлужебныеПроцедурыИФункции