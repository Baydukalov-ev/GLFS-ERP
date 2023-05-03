
&ИзменениеИКонтроль("ДанныеДляОбработкиОчередиОповещений")
Функция бг_ДанныеДляОбработкиОчередиОповещений(ТипСобытия) Экспорт

	СтруктураДанных = СтруктураДанныхДляОповещения();

	Если ТипСобытия = Перечисления.ТипыСобытийОповещений.ПоздравлениеСДнемРождения Тогда

		СтруктураДанных.ПутьККонтактномуЛицу                             = "";
		СтруктураДанных.ОтправлятьПартнеру                               = Ложь;
		СтруктураДанных.ОтправлятьКонтактнымЛицамПартнера                = Ложь;
		СтруктураДанных.Имя                                              = "ПоздравлениеСДнемРождения";

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ПросроченнаяЗадолженность Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.Имя                                              = "ПросроченнаяЗадолженность";

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ПлановыеПлатежи Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.Имя                                              = "ПлановыеПлатежи";

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.НачислениеБонусов Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.Имя                                              = "НачислениеБонусов";
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммыЛояльности")
		                                                                    И ПравоДоступа("Чтение", Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов)
		                                                                    И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.БонусныеБаллы);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.СписаниеБонусов Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.Имя                                              = "СписаниеБонусов";
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммыЛояльности")
		                                                                    И ПравоДоступа("Чтение", Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов)
		                                                                    И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.БонусныеБаллы);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ИзменениеСостоянияЗаказа Тогда

		СтруктураДанных.ПутьККонтактномуЛицу                             = ".КонтактноеЛицо";
		СтруктураДанных.Имя                                              = "ИзменениеСостоянияЗаказа";
		СтруктураДанных.ВШаблонеДоступнаВнешняяСсылка                    = Истина;
		СтруктураДанных.МетаданныеИсточникаОповещения                    = Метаданные.Документы.ЗаказКлиента;
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов")
																			И ПравоДоступа("Чтение", Метаданные.Документы.ЗаказКлиента);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ПлановыеОтгрузки Тогда

		СтруктураДанных.ПутьККонтактномуЛицу                             = ".КонтактноеЛицо";
		СтруктураДанных.Имя                                              = "ПлановыеОтгрузки";
		СтруктураДанных.ДоступноДляИспользования                         = ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыКлиентов);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ВыпискаСчета Тогда

		СтруктураДанных.ПутьККонтактномуЛицу                             = ".КонтактноеЛицо";
		СтруктураДанных.Имя                                              = "ВыпискаСчета";
		СтруктураДанных.ВШаблонеДоступнаВнешняяСсылка                    = Истина;
		СтруктураДанных.МетаданныеИсточникаОповещения                    = Метаданные.Документы.СчетНаОплатуКлиенту;
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам")
																			И ПравоДоступа("Чтение", Метаданные.Документы.СчетНаОплатуКлиенту);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.АннулированиеСчета Тогда

		СтруктураДанных.ПутьККонтактномуЛицу                             = ".КонтактноеЛицо";
		СтруктураДанных.Имя                                              = "АннулированиеСчета";
		СтруктураДанных.ВШаблонеДоступнаВнешняяСсылка                    = Истина;
		СтруктураДанных.МетаданныеИсточникаОповещения                    = Метаданные.Документы.СчетНаОплатуКлиенту;
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам")
																			И ПравоДоступа("Чтение", Метаданные.Документы.СчетНаОплатуКлиенту);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ИзменениеСчета Тогда

		СтруктураДанных.ПутьККонтактномуЛицу                             = ".КонтактноеЛицо";
		СтруктураДанных.Имя                                              = "ИзменениеСчета";
		СтруктураДанных.ВШаблонеДоступнаВнешняяСсылка                    = Истина;
		СтруктураДанных.МетаданныеИсточникаОповещения                    = Метаданные.Документы.СчетНаОплатуКлиенту;
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам")
																			И ПравоДоступа("Чтение", Метаданные.Документы.СчетНаОплатуКлиенту);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ПоступлениеОплатыОтКлиента Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.Имя                                              = "ПоступлениеОплатыОтКлиента";
		СтруктураДанных.ДоступноДляИспользования                         = ПравоДоступа("Чтение", Метаданные.Документы.ПриходныйКассовыйОрдер)
																			И ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств)
																			И ПравоДоступа("Чтение", Метаданные.Документы.ОперацияПоПлатежнойКарте)
																			И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.РасчетыСКлиентами);

	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.ОкончаниеОпроса Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.Имя                                              = "ОкончаниеОпроса";
		СтруктураДанных.ДоступноДляИспользования                         = ПолучитьФункциональнуюОпцию("ИспользоватьАнкетирование");

#Вставка
	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.бг_ИзменениеАлкогольнойЛицензииПоставщика Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.ОтправлятьПартнеру      						 = Ложь;
		СтруктураДанных.ОтправлятьКонтактнымЛицамПартнера     			 = Ложь;
		СтруктураДанных.Имя                                              = "бг_ИзменениеАлкогольнойЛицензииПоставщика";
	
	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.бг_ЗагрузкаИнформацииПоЛицензиям Тогда

		СтруктураДанных.ОтправлятьКонтактнымЛицамОбъектаОповещения       = Ложь;
		СтруктураДанных.ОтправлятьПартнеру      						 = Ложь;
		СтруктураДанных.ОтправлятьКонтактнымЛицамПартнера     			 = Ложь;
		СтруктураДанных.Имя                                              = "бг_ЗагрузкаИнформацииПоЛицензиям";
	
	ИначеЕсли ТипСобытия = Перечисления.ТипыСобытийОповещений.бг_ОтгрузкаГотовойПродукции Тогда

		СтруктураДанных.Имя                                              = "бг_ОтгрузкаГотовойПродукции";

#КонецВставки

	Иначе

		МодификацияКонфигурацииПереопределяемый.НастройкиТипаСобытияДляОбработкиОчередиОповещений(ТипСобытия, СтруктураДанных);

	КонецЕсли;

	Возврат СтруктураДанных;

КонецФункции