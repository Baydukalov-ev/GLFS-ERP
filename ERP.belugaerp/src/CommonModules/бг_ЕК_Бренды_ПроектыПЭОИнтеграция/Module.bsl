#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ОставитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		ВыгружаемыеРеквизиты());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()
	
	ВыгружаемыеРеквизиты = Новый Массив;
	
	ВыгружаемыеРеквизиты.Добавить("Предопределенный");
	ВыгружаемыеРеквизиты.Добавить("ПометкаУдаления");
	ВыгружаемыеРеквизиты.Добавить("Код");
	ВыгружаемыеРеквизиты.Добавить("Наименование");
	ВыгружаемыеРеквизиты.Добавить("ПорядокВывода");
	ВыгружаемыеРеквизиты.Добавить("МетодГруппировкиВКПК");
	
	ВыгружаемыеРеквизиты = СтрСоединить(ВыгружаемыеРеквизиты, ",");
	
	Возврат ВыгружаемыеРеквизиты;
	
КонецФункции

#КонецОбласти
