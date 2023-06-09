
&НаКлиенте
&ИзменениеИКонтроль("Печать")
Процедура бг_Печать(Команда)

	ТабличныеДокументы = ТабличныеДокументыДляПечати();
	УправлениеПечатьюКлиент.РаспечататьТабличныеДокументы(ТабличныеДокументы, ОбъектыПечати,
	ТабличныеДокументы.Количество() > 1, ?(НастройкиПечатныхФорм.Количество() > 1, Копий, 1));

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		СписокПечати = Новый СписокЗначений; 
		Для Каждого ПечатнаяФорма Из НастройкиПечатныхФорм Цикл
			СписокПечати.Добавить(ПечатнаяФорма.ИмяМакета, ПечатнаяФорма.Название);
		КонецЦикла;
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.ЗаписатьСостоянияОригиналовПослеПечати(ОбъектыПечати, СписокПечати);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
#Вставка
	бг_ФиксацияПечатиДокументовКлиент.ЗафиксироватьПечатьДокументов(
		ТабличныеДокументы, 
		ОбъектыПечати, 
		СписокПечати);	
#КонецВставки

	Оповестить("ТабличныеДокументыНапечатаны", ТабличныеДокументы, ОбъектыПечати);

КонецПроцедуры
